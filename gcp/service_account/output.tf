output "email" {
  value = "${google_service_account.account.email}"
}

output "name" {
  value = "${google_service_account.account.name}"
}

output "id" {
  value = "${google_service_account.account.id}"
}

output "private_key" {
  value = "${google_service_account_key.account.private_key}"
}