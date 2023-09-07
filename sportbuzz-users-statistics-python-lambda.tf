
data "aws_ecr_repository" "sportbuzz-users-statistics-python" {
  name = "sportbuzz-users-statistics-python"
}

resource "aws_lambda_function" "sportbuzz-users-statistics-python-lambda" {
  function_name = "sportbuzz-users-statistics-python-lambda"
  timeout       = 5 # seconds
  image_uri     = "666519825349.dkr.ecr.us-east-1.amazonaws.com/sportbuzz-users-statistics-python:latest"
  package_type  = "Image"

  role = aws_iam_role.sportbuzz-users-statistics-function-role.arn

  environment {
    variables = {
      ENVIRONMENT = "AWS"
    }
  }
}

resource "aws_iam_role" "sportbuzz-users-statistics-function-role" {
  name = "sportbuzz-users-statistics-function-role"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_cloudwatch_log_group" "sportbuzz-users-statistics-python-lambda" {
  name              = "/aws/lambda/${aws_lambda_function.sportbuzz-users-statistics-python-lambda.function_name}"
  retention_in_days = 14
}
resource "aws_iam_policy" "sportbuzz-users-statistics-python-lambda" {
  name        = "sportbuzz-users-statistics-python-lambda"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-logs" {
  role       = aws_iam_role.sportbuzz-users-statistics-lambda-role.name
  policy_arn = aws_iam_policy.sportbuzz-users-statistics-python-lambda.arn
}

resource "aws_iam_role" "sportbuzz-users-statistics-lambda-role" {
  name               = "sportbuzz-users-statistics-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}