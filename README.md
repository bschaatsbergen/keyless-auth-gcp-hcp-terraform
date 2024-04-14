# Keyless Authentication Between Terraform Cloud & Google Cloud

Securely connect to a Google Kubernetes Engine (GKE) Cluster using Terraform, SSH, and Identity-Aware Proxy.

## Features

This configuration provides ready-to-use resources for production:

- Workload Identity Federation for Terraform Cloud.
- An example Service Account which Terraform Cloud can use to authenticate with Google Cloud.
- A Terraform Cloud Variable Set containing sensitive information about the example Service Account.
