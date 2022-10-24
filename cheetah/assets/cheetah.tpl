# Server configurations
server:
  host: "10.42.42.42"
  port: 8000

# Database credentials
database:
  user: "cheetah_user"
  pass: "${database_password}"

# Storage bucket
gcs:
  bucket: "${bucket_name}"
  object: "cheetah.jpg"
