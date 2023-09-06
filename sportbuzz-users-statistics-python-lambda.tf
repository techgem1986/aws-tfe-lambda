
data "aws_ecr_repository" "sportbuzz-users-statistics-python" {
  name = "sportbuzz-users-statistics-python"
}

resource "aws_lambda_function" "sportbuzz-users-statistics-python-lambda" {
  function_name = "sportbuzz-users-statistics-python-lambda"
  timeout       = 5 # seconds
  image_uri     = "666519825349.dkr.ecr.us-east-1.amazonaws.com/sportbuzz-users-statistics-python:795ebcda05fc48cdf3a8acbc83c8ea564c7e5110"
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