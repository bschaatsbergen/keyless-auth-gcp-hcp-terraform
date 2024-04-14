locals {
  # list of Terraform Cloud workspace IDs where the Workload Identity Federation configuration can be accessed
  terraform_cloud_workspace_ids = [
    "ws-ZZZZZZZZZZZZZZZ",
  ]
}

# create a workload identity pool for Terraform Cloud
resource "google_iam_workload_identity_pool" "tf_cloud" {
  project                   = var.google_project_id
  workload_identity_pool_id = "tf-cloud-pool"
  display_name              = "Terraform Cloud Pool"
  description               = "Used to authenticate to Google Cloud"
}

# create a workload identity pool provider for Terraform Cloud
resource "google_iam_workload_identity_pool_provider" "tf_cloud" {
  project                            = var.google_project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.tf_cloud.workload_identity_pool_id
  workload_identity_pool_provider_id = "tf-cloud-provider"
  display_name                       = "Terraform Cloud Provider"
  description                        = "Used to authenticate to Google Cloud"
  attribute_condition                = "assertion.terraform_organization_name==\"${var.tfc_organization_name}\""
  attribute_mapping = {
    "google.subject"                     = "assertion.sub"
    "attribute.terraform_workspace_id"   = "assertion.terraform_workspace_id"
    "attribute.terraform_full_workspace" = "assertion.terraform_full_workspace"
  }
  oidc {
    issuer_uri = "https://app.terraform.io"
  }
}

# example service account that Terraform Cloud will impersonate
resource "google_service_account" "example" {
  project      = var.google_project_id
  account_id   = "example"
  display_name = "Service Account for Terraform Cloud"
}

# IAM should verify the Terraform Cloud Workspace ID before authorizing access to impersonate the 'example' service account
resource "google_service_account_iam_member" "example_workload_identity_user" {
  for_each           = toset(local.terraform_cloud_workspace_ids)
  service_account_id = google_service_account.example.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tf_cloud.name}/attribute.terraform_workspace_id/${each.value}"
}

# this is how the 'example' service account gets its permissions/roles
resource "google_project_iam_member" "example_storage_admin" {
  project = var.google_project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.example.email}"
}

# create a variable set to store the Workload Identity Federation config for the 'example' service account
resource "tfe_variable_set" "example" {
  name         = google_service_account.example.account_id
  description  = "Workload Identity Federation configuration for ${google_service_account.example.name}"
  organization = var.tfc_organization_name
}

resource "tfe_variable" "example_provider_auth" {
  key             = "TFC_GCP_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.example.id
}

resource "tfe_variable" "example_service_account_email" {
  sensitive       = true
  key             = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value           = google_service_account.example.email
  category        = "env"
  variable_set_id = tfe_variable_set.example.id
}

resource "tfe_variable" "example_provider_name" {
  sensitive       = true
  key             = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
  value           = google_iam_workload_identity_pool_provider.tf_cloud.name
  category        = "env"
  variable_set_id = tfe_variable_set.example.id
}

# share the variable set with a Terraform Cloud workspace
resource "tfe_workspace_variable_set" "example" {
  for_each        = toset(local.terraform_cloud_workspace_ids)
  variable_set_id = tfe_variable_set.example.id
  workspace_id    = each.value
}
