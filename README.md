# Airflow Google Cloud Cluster
## Terraform
## Kubernetes

## Docker images
if you want to push a new Docker image to the GCP Artifact Registry

### Authenticate Docker against gcp
gcloud auth configure-docker us-central1-docker.pkg.dev

###  Build docker image
docker build -t us-central1-docker.pkg.dev/airflow-test-cluster/airflow-gke-test/airflow-plugins-dependencies:1.0.0 .

###  Push docker image
docker push us-central1-docker.pkg.dev/airflow-test-cluster/airflow-gke-test/airflow-plugins-dependencies:1.0.0


> Note that the image name has a very specific structure
> - `us-central1-docker.pkg.dev` refers to the zone of the Docker registry.
> - `airflow-test-cluster` is the Project ID of this GCP project. Note that it will be different for you.
> - `airflow-gke-test` is the name we gave to our Docker repository on Artifact Registry.
> - `airflow-plugins-dependencies` is the Docker image’s name.
> - `1.0.0` is the Docker image’s tag.
