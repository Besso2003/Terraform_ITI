# resource "aws_s3_bucket_notification" "state_change_trigger" {

#   bucket = "bassant-tf-state-s3"

#   lambda_function {

#     lambda_function_arn = aws_lambda_function.send_email.arn

#     events = [
#       "s3:ObjectCreated:*"
#     ]

#     filter_suffix = ".tfstate"
#   }
# }