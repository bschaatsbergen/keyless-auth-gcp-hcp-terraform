resource "google_storage_bucket" "example" {
  name     = "example"
  location = "EU"
  project  = var.google_project_id
}
