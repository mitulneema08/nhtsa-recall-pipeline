resource "google_storage_bucket" "bronze" {
  name                        = "${var.project_id}-bronze"
  location                    = var.region
  force_destroy               = false
  uniform_bucket_level_access = true
}

resource "google_bigquery_dataset" "silver" {
  dataset_id  = "nhtsa_silver"
  location    = var.region
  description = "Cleaned, typed recall data - populated by dbt"
}

resource "google_bigquery_dataset" "gold" {
  dataset_id  = "nhtsa_gold"
  location    = var.region
  description = "Analytics-ready marts feeding Power BI dashboard"
}

resource "google_storage_bucket" "tfstate" {
  name                        = "${var.project_id}-tfstate"
  location                    = var.region
  force_destroy               = false
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}