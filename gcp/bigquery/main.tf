resource "google_project_iam_custom_role" "job_get_create_access" {
  role_id     = "bigquery.jobCreateGetRole"
  title       = "Role with jobs create & jobs get access"
  description = "Role with jobs create & jobs get access"
  permissions = ["bigquery.jobs.create", "bigquery.jobs.get"]
}

resource "google_project_iam_binding" "job_get_create_access" {
  project = var.project_id
  role = "projects/${var.project_id}/roles/bigquery.jobCreateGetRole"
  members = compact(split(",", replace(var.job_get_create_members, " ", "")))
}

resource "google_service_account" "bigquery-connector" {
  account_id   = "bigquery-connector"
  display_name = "service account used to write billing data to bigquery"
}

resource "google_service_account_key" "bigquery-connector" {
  service_account_id = google_service_account.bigquery-connector.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "bigquery-connector" {
  project = var.project_id
  role    = "roles/bigquery.dataOwner"
  member  = "serviceAccount:${google_service_account.bigquery-connector.email}"
}

resource "google_project_iam_binding" "write_access" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  members = compact(split(",", replace(var.write_members, " ", "")))
}

resource "google_project_iam_binding" "job_access" {
  project = var.project_id
  role = "roles/bigquery.jobUser"
  members = compact(split(",", replace(var.job_members, " ", "")))
}

resource "google_project_iam_binding" "view_access" {
  project = var.project_id
  role = "roles/bigquery.dataViewer"
  members = compact(split(",", replace(var.view_members, " ", "")))
}
