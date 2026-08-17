resource "google_pubsub_topic" "recall_updates" {
  name = "recall-updates"
  project = var.project_id
}

resource "google_bigquery_table" "streaming_recall_events" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.gold.dataset_id
  table_id   = "streaming_recall_events"

  schema = jsonencode([
    { name = "campaign_number", type = "STRING", mode = "NULLABLE" },
    { name = "recall", type = "STRING", mode = "NULLABLE" },
    { name = "model", type = "STRING", mode = "NULLABLE" },
    { name = "manufacturer", type = "STRING", mode = "NULLABLE" },
    { name = "event_type", type = "STRING", mode = "NULLABLE" },
    { name = "event_time", type = "TIMESTAMP", mode = "NULLABLE" }
  ])
}

data "google_project" "current" {
    project_id = var.project_id
}

resource "google_bigquery_dataset_iam_member" "pubsub_bq_writer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.gold.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription" "recall_updates_to_bq" {
  name  = "recall-updates-to-bq"
  topic = google_pubsub_topic.recall_updates.name
  project = var.project_id

  bigquery_config {
    table            = "${var.project_id}.${google_bigquery_dataset.gold.dataset_id}.${google_bigquery_table.streaming_recall_events.table_id}"
    use_topic_schema = false
    use_table_schema = true
    write_metadata   = false
  }

  depends_on = [google_bigquery_dataset_iam_member.pubsub_bq_writer]
}