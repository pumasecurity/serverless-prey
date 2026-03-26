output "cheetah_function_url" {
  description = "Cheetah HTTP Url"
  value       = google_cloudfunctions2_function.cheetah.url
}

output "cheetah_api_key" {
  description = "Cheetah function API key"
  value       = random_string.cheetah_api_key.id
}
