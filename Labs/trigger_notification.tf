resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::bassant-tf-state"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "bassant-tf-state"

  lambda_function {
    lambda_function_arn = aws_lambda_function.send_email.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".tfstate"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}