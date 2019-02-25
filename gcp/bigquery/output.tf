output "account_email" {
  value = "${google_service_account.bigquery-connector.email}"
}

output "readonly_role" {
  value = "roles/bigquery.dataViewer"
}

output "editor_role" {
  value = "roles/bigquery.dateEditor"
}