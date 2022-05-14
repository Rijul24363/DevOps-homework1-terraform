
provider "aws" {
  region     = "ap-south-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}


data "aws_iam_user" "name" {
    user_name = "rizul123"
}

output "user" {
value = "${data.aws_iam_user.name.user_name}"
}