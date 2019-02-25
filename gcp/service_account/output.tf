output "email" {
  value = "${google_service_account.account.email}"
}

output "private_key" {
  value = "${google_service_account_key.account.private_key}"
}