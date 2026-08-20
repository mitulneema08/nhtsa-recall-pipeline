variable "project_id" {
  description = "GCP project ID for the NHTSA recall pipeline"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}