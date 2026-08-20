resource "google_service_account" "github_actions_ci" {
  account_id   = "github-actions-ci"
  display_name = "GitHub Actions CI (read-only: plan + dbt test)"
  project      = var.project_id
}

resource "google_project_iam_member" "ci_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.github_actions_ci.email}"
}

resource "google_project_iam_member" "ci_bq_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.github_actions_ci.email}"
}

resource "google_storage_bucket_iam_member" "ci_tfstate_writer" {
  bucket = google_storage_bucket.tfstate.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github_actions_ci.email}"
}