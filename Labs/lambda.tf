data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./lambda/lambda_function.py"
  output_path = "./lambda/lambda.zip"
}

resource "aws_lambda_function" "send_email" {

  function_name = "send-email-lambda"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.12"

  handler = "lambda_function.lambda_handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}