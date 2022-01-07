# Bot Root

resource "aws_lambda_function" "exam_bot" {
  function_name = var.lambda_function_name

  s3_bucket = aws_s3_bucket.exam_bot_bucket.id
  s3_key    = "bundle.zip"

  runtime = "nodejs12.x"
  handler = "hello.handler"

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      API_URL = "Bot Mane"
      PAGE_ACCESS_TOKEN = "HELLO TOKEN"
      PAGE_ID = "PAGE_ID"
    }
  }
}

resource "aws_cloudwatch_log_group" "exam_bot" {
  name = "/aws/lambda/${aws_lambda_function.exam_bot.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_s3_bucket" "exam_bot_bucket" {
  bucket = var.bucket_name

  acl           = "private"
  force_destroy = true
}