terraform {
  cloud {
    organization = var.tfc_organization
    workspaces {
      name = "setup-wif"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
  }
}

provider "tfe" {
  token = var.tfc_token
}
