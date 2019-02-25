resource "google_service_account" "account" {
  account_id   = "${var.name}"
  display_name = "${var.description}"
  project      = "${var.project_id}"
}

resource "google_service_account_key" "account" {
  service_account_id = "${google_service_account.account.name}"
  public_key_type    = "TYPE_X509_PEM_FILE"
}
