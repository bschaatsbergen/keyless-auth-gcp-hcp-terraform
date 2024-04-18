# Keyless Google Cloud Access from HCP Terraform

Securely access Google Cloud from HCP Terraform using Google's Workload Identity Federation, eliminating the need for storing service account keys.

## What is identity federation?
Identity federation lets HCP Terraform impersonate a service account through its native OpenID Connect integration and obtain a short-lived OAuth 2.0 access token. This short-lived access token lets you call any Google Cloud APIs that the service account has access to at runtime, making your HCP Terraform runs much more secure.

## Using Workload Identity Federation
Using HashiCorp Terraform, you have the ability to create a Workload Identity [Pool](https://cloud.google.com/iam/docs/workload-identity-federation#pools) and [Provider](https://cloud.google.com/iam/docs/workload-identity-federation#providers), which HCP Terraform uses to request a federated token from. This token is then passed to the Google Terraform provider, which impersonates a service account to obtain temporary credentials to plan or apply Terraform with.
