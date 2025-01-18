resource "aws_iam_role" "lambda_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = merge(local.common_tags, {
    Name = "lambda-origin-request-${var.name}-${var.environment}"
  })
}

data "archive_file" "origin_request_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/origin_request.js"
  output_path = "${path.module}/lambda_artifact_origin_request_lambda.zip"
}

resource "aws_lambda_function" "origin_request_lambda" {
  filename      = data.archive_file.origin_request_lambda.output_path
  function_name = "lambda-origin-request-${var.name}-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "origin_request.handler"

  source_code_hash = filebase64sha256(data.archive_file.origin_request_lambda.output_path)

  runtime = "nodejs18.x"

  publish = true
  tags = merge(local.common_tags, {
    Name = "lambda-origin-request-${var.name}-${var.environment}"
  })
}