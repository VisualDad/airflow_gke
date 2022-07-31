variable "gcp_credentials" {
  type=string
  description= "Location of service account"
}

variable "gcp_project_id" {
  type=string
  description= "Gcp Project id"
}


variable "gcp_region" {
  type=string
  description= "gcp region"
}

variable "gke_regional" {
  type=string
  description= "gcp region"
}


variable "gke_cluster_name" {
  type=string
  description= "GKE Cluster name"
}

variable "gke_zones" {
  type=list(string)
  description= "list of zones for the gke cluster"
}



variable "gke_network" {
  type=string
  description= "VPC Network"
}


variable "gke_subnetwork" {
  type=string
  description= "VPC Network"
}


variable "gke_default_nodepool_name" {
  type=string
  description= "gke default noepool name"
}

variable "gke_service_account_name" {
  type=string
  description= "gke service account name"
}






