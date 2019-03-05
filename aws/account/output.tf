output "arn" {
  value = "${aws_iam_user.user.arn}"
}

output "name" {
  value = "${aws_iam_user.user.name}"
}

output "key_id" {
  value = "${aws_iam_access_key.key.id}"
}

output "key_secret" {
  value = "${aws_iam_access_key.key.secret}"
}
