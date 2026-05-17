data "aws_iam_role" "lambda_role" {
  name = "lambda-ses-role"
}


# The Problem in here is first i created one role lambda-ses-role after i run apply dev but then when i run apply prod it show error that it cant create the role,
# which is because it was created and roles are global, so then i created for each dev and prod a role for each,
# but then i dont think that was the best approach to solve the problem because i will have many roles if i have many environments, so the best approach is to create one role and use it for all environments
# so i created one manually in the console and then i used data source to get it and use it in the lambda function, so now i can run apply for both dev and prod without any error because the role is already created and shared between them.

# resource "aws_iam_role" "lambda_role" {
#   name = "lambda-ses-role-${terraform.workspace}"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_basic" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# resource "aws_iam_role_policy" "ses_policy" {
#   name = "lambda-ses-policy-${terraform.workspace}"
#   role = aws_iam_role.lambda_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Action = ["ses:SendEmail", "ses:SendRawEmail"],
#       Resource = "*"
#     }]
#   })
# }