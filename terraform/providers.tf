terraform {
  # this bucket needs to be created beforehand
  # enable object versioning
  # https://www.terraform.io/language/settings/backends/gcs
  backend "gcs" {
    bucket = "tf-tornado"
    prefix = "terraform/state"
  }
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs
    google = {
      source  = "hashicorp/google"
      version = "4.25.0"
    }
  }
}

provider "google" {
  # best to use Service Account created specifically for Terraform
  # auth options: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication

  project = "krisi-playground"
  region  = "europe-west1"
  zone    = "europe-west1-c"
}

