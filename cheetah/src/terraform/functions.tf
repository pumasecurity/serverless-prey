# Function API key
resource "random_string" "cheetah_api_key" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# Function service account
resource "google_service_account" "cheetah" {
  count = var.configure_ctf ? 1 : 0

  account_id   = "cheetah-${var.unique_identifier}"
  display_name = "serverless-prey-cheetah-${var.unique_identifier}"
  description  = "Serverless Prey Cheetah service account"
}

# Function access to logging
resource "google_project_iam_member" "cheetah_logging" {
  count = var.configure_ctf ? 1 : 0

  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cheetah[0].email}"
}

# Function secrets accessor
resource "google_secret_manager_secret_iam_member" "cheetah_secret" {
  count = var.configure_ctf ? 1 : 0

  project   = var.project_id
  secret_id = google_secret_manager_secret.cheetah[0].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cheetah[0].email}"
}

# Function storage bucket access
resource "google_storage_bucket_iam_member" "cheetah_storage" {
  count = var.configure_ctf ? 1 : 0

  bucket = google_storage_bucket.cheetah[0].name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cheetah[0].email}"
}

resource "google_cloudfunctions_function" "cheetah" {
  depends_on = [
    google_project_service.iam,
    google_project_service.cloudkms,
    google_project_service.secretmanager,
    google_project_service.functions,
    google_project_service.logging,
    google_project_service.cloudbuild,
    google_project_service.storage,
    google_storage_bucket.function,
    google_secret_manager_secret.cheetah,
    google_storage_bucket.cheetah,
  ]

  available_memory_mb = "256"
  entry_point         = "Cheetah"
  ingress_settings    = "ALLOW_ALL"

  name                  = "serverless-prey-cheetah-${var.unique_identifier}"
  project               = var.project_id
  region                = var.region
  runtime               = "go122"
  service_account_email = var.configure_ctf ? google_service_account.cheetah[0].email : "${var.project_id}@appspot.gserviceaccount.com"
  timeout               = 60
  trigger_http          = true
  source_archive_bucket = google_storage_bucket.function.name
  source_archive_object = "${data.archive_file.function_cheetah.output_md5}.zip"

  environment_variables = {
    CHEETAH_API_KEY          = random_string.cheetah_api_key.id
    CHEETAH_PROJECT_ID       = var.project_id
    CHEETAH_SECRET_NAME      = var.configure_ctf ? google_secret_manager_secret.cheetah[0].secret_id : ""
    CHEETAH_LOG_NAME         = "serverless-prey-cheetah-${var.unique_identifier}"
    CHEETAH_FUNCTION_TIMEOUT = 60
  }
}

# IAM Configuration. This allows authenticated access to the TF identity
# Change this if you require more (or less) access
resource "google_cloudfunctions_function_iam_member" "cheetah" {
  project        = var.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.cheetah.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
