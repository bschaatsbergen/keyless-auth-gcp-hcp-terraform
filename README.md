# Keyless Google Cloud Access from Terraform Cloud

This configuration enables secure access to Google Cloud from Terraform Cloud without the use of service account keys. It uses Workload Identity Federation, a Google Cloud service that uses OpenID Connect for authentication.

# Features:

* Workload Identity Federation: Establishes trust between Terraform Cloud and Google Cloud.
* Example Service Account: Used by Terraform Cloud to authenticate with Google Cloud.
* Terraform Cloud Variable Set: Stores sensitive information about the example service account.
