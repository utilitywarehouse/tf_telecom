

resource "aws_iam_user" "user" {
  name = "${format("/%s/", replace(var.team, "/^uw-/", ""))}-${var.name}"
}


resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}