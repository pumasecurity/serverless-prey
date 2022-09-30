output "cheetah_function_url" {
  description = "Cheetah HTTP Url"
  value       = google_cloudfunctions_function.cheetah.https_trigger_url
}
