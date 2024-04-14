terraform {
  cloud {
    organization = var.tfc_organization
    workspaces {
      name = "use-wif"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
  }
}
