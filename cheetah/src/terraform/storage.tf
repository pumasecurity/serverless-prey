resource "google_storage_bucket" "function" {
  depends_on = [
    google_project_service.iam,
    google_project_service.cloudkms,
    google_project_service.secretmanager,
    google_project_service.functions,
    google_project_service.logging,
    google_project_service.cloudbuild,
    google_project_service.storage,
  ]

  name     = "serverless-prey-${var.unique_identifier}"
  location = var.region

  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "random_uuid" "cheetah_config_flag" {
  count = var.configure_ctf ? 1 : 0
}

resource "random_uuid" "cheetah_config_name" {
  count = var.configure_ctf ? 1 : 0
}

resource "random_uuid" "cheetah_storage_flag" {
  count = var.configure_ctf ? 1 : 0
}

data "template_file" "cheetah_config" {
  template = file("${path.module}/../../assets/cheetah.tpl")
  vars = {
    database_password = var.configure_ctf ? "${var.flag_prefix}{${random_uuid.cheetah_config_flag[0].id}}" : "TmV2ZXIgcGxheSBwb2tlciB3aXRoIHRoZSB3b3JsZCdzIGZhc3Rlc3QgYW5pbWFsLCBiZWNhdXNlIGhlJ3MgYSBjaGVldGFoLiAtIGNvb2xmdW5ueXF1b3Rlcy5jb20g"
    bucket_name       = "cheetah-${var.configure_ctf ? random_uuid.cheetah_config_name[0].id : var.unique_identifier}"
  }
}

resource "local_file" "cheetah_config" {
  filename = "${path.module}/../cheetah/cheetah.yaml"
  content  = data.template_file.cheetah_config.rendered
}

data "archive_file" "function_cheetah" {
  depends_on = [
    google_storage_bucket.function,
    local_file.cheetah_config,
  ]

  type        = "zip"
  source_dir  = "${path.module}/../cheetah"
  output_path = "${path.module}/../publish/cheetah.zip"
}

resource "google_storage_bucket_object" "function_cheetah" {
  name   = "${data.archive_file.function_cheetah.output_md5}.zip"
  bucket = google_storage_bucket.function.name
  source = data.archive_file.function_cheetah.output_path
}

resource "google_storage_bucket" "cheetah" {
  count = var.configure_ctf ? 1 : 0

  depends_on = [
    google_project_service.iam,
    google_project_service.cloudkms,
    google_project_service.secretmanager,
    google_project_service.functions,
    google_project_service.logging,
    google_project_service.cloudbuild,
    google_project_service.storage,
  ]

  name     = "cheetah-${random_uuid.cheetah_config_name[0].id}"
  location = var.region

  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "cheetah" {
  count = var.configure_ctf ? 1 : 0

  name   = "cheetah.jpg"
  bucket = google_storage_bucket.cheetah[0].name
  source = "${path.module}/../../assets/cheetah.jpg"

  metadata = {
    "flag" = "${var.flag_prefix}{${random_uuid.cheetah_storage_flag[0].id}}"
  }
}
