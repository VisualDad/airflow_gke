locals {
  auth_fernet_key = base64encode(substr(random_password.fernet_key.result, 0, 32))
  postgresql_enable_embedded = true
}


resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "airflow-gke-test"
  description   = "Docker repository for custom Airflow images"
  format        = "DOCKER"
}


resource "kubernetes_secret" "ssh_key_airflow_gke_test" {
  metadata {
    name      = "airflow-git-ssh-secret-test"
  }

  data = {
    "id_rsa" = file("/Users/Thomas/.ssh/airflow-gke-test")
  }

  type = "Opaque"
}


resource "helm_release" "airflow" {
  name       = "airflow"
  # repository = "https://artifacthub.io/packages/helm/airflow-helm/airflow/8.5.0"
  chart      = "airflow-kubernetes-chart"
  namespace  = "default"
  timeout    = 3600
  wait = true
  # version = "2.1.2"
  values = [
    "${file("airflow-kubernetes-chart/values.yaml")}"
  ]

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }


  set {
    name  = "uid"
    value = 1000
  }

  set {
    name  = "gid"
    value = 1000
  }

  set_sensitive {
    name = "airflow.fernetKey"
    value = local.auth_fernet_key
  }

  set {
    name = "postgresql.enabled"
    value = local.postgresql_enable_embedded
  }

  set {
    name = "redis.enabled"
    value = false
  }

  set {
  name = "workers.enabled"
  value = false
  }

  set {
  name = "flower.enabled"
  value = false
  }

  set {
  name = "redis.enabled"
  value = false
  }

  set {
    name = "airflow.executor"
    value = "KubernetesExecutor,"
  }

  set_sensitive {
    name = "airflow.webserverSecretKey"
    value = random_password.webserverSecretKey.result
  }

}

resource random_password "fernet_key" {
  length = 128
}

resource random_password "webserverSecretKey" {
  length = 128
}


resource "google_container_cluster" "primary" {
  name     = "airflow-test-cluster"
  location = "us-central1"
  node_locations = [
    "us-central1-a"
  ]


  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-custom-node-pool"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

}