# consider exporting existing resources with
# https://cloud.google.com/docs/terraform/resource-management/export
# have a look at https://github.com/terraform-google-modules/

# as google_artifact_registry_repository is currently in beta
resource "google_container_registry" "tornado-images" {
  location = "EU"
}


resource "google_cloud_run_service" "hello" {
  name     = "cloudrun-srv"
  location = "europe-west1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_pubsub_topic" "scheduled-things" {
  name = "scheduled-things"
}

resource "google_cloud_scheduler_job" "queue-pusher" {
  name        = "queue-pusher"
  description = "test job"
  schedule    = "*/2 * * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.scheduled-things.id
    data       = base64encode("test")
  }
}