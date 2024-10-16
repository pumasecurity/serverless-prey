resource "random_uuid" "cheetah_secret_name" {
  count = var.configure_ctf ? 1 : 0
}

resource "google_secret_manager_secret" "cheetah" {
  count = var.configure_ctf ? 1 : 0

  secret_id = "cheetah-${random_uuid.cheetah_secret_name[0].id}"

  replication {
    auto {}
  }
}

resource "random_uuid" "cheetah_secret_flag" {
  count = var.configure_ctf ? 1 : 0
}

resource "google_secret_manager_secret_version" "cheetah" {
  count = var.configure_ctf ? 1 : 0

  secret      = google_secret_manager_secret.cheetah[0].id
  secret_data = "${var.flag_prefix}{${random_uuid.cheetah_secret_flag[0].id}}"
}
