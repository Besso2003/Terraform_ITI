resource "aws_lambda_permission" "allow_s3" {
  provider       = aws.backend
  statement_id  = "AllowS3Invoke-${var.environment}" 
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.send_email.function_name
  principal      = "s3.amazonaws.com"
  source_arn     = "arn:aws:s3:::bassant-tf-state-v2"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  provider = aws.backend
  bucket   = "bassant-tf-state-v2"

  lambda_function {
    lambda_function_arn = aws_lambda_function.send_email.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".tfstate"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}