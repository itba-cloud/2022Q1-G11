# Define the policy for the role
#resource "aws_iam_role_policy" "policy-lambda" {
#  name = var.iam_policy_name
#  role = "${aws_iam_role.role-lambda.id}"

#  policy = var.iam_policy_content
#}

# Define the role
#resource "aws_iam_role" "role-lambda" {
#name        = var.iam_role_name
#description = "Role to assume as lambda."

#assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#}

resource "aws_lambda_function" "this" {
  filename      = var.filename
  function_name = var.function_name
  role          = var.iam_role_arn
  handler       = var.handler
  description   = var.desc
  runtime       = var.runtime

  vpc_config {
    subnet_ids         = [var.private_subnet_id]
    security_group_ids = [var.lambda_sg_id]
  }

  tags = {
    Name = var.lambda_tag_name
  }

}