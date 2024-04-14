locals {
  google_project_id = "example-project"
}

resource "google_storage_bucket" "example" {
  name     = "example"
  location = "EU"
  project  = local.google_project_id
}
