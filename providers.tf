terraform {
  required_providers {
    kubernetes = "~>1.13.3"
    helm       = "~>1.3.2"
  }
}


provider "google" {
  credentials = file(var.gcp_credentials)
  project = var.gcp_project_id
  region = var.gcp_region
}


# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}


provider  "kubernetes" {
  host = "https://${google_container_cluster.primary.endpoint}"
  # token = data.google_client_config.default.access_token

  client_certificate = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
  client_key = base64decode(google_container_cluster.primary.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
  host = "https://${google_container_cluster.primary.endpoint}"
  # token = data.google_client_config.default.access_token

  client_certificate = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
  client_key = base64decode(google_container_cluster.primary.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}