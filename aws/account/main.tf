

resource "aws_iam_user" "user" {
  name = "${format("/%s/", replace(var.team, "/^uw-/", ""))}-${var.name}"
  tags {
    team = "${format("/%s/", replace(var.team, "/^uw-/", ""))}"
  }
}


resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}