

resource "aws_iam_user" "user" {
  name = "${var.name}"
  path = "${format("/uw-%s/", replace(var.team, "/^uw-/", ""))}"
}


resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}