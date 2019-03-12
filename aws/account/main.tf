

resource "aws_iam_user" "user" {
  name = "${format("%s", replace(var.team, "/^uw-/", ""))}-${var.name}"
  permissions_boundary = "arn:aws:iam::${var.account_id}:policy/sys-${format("%s", replace(var.team, "/^uw-/", ""))}-boundary"
  tags {
    team = "${format("%s", replace(var.team, "/^uw-/", ""))}"
    terraform = "Managed by terraform"
  }
}


resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}