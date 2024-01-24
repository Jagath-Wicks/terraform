resource "aws_lambda_function" "terraform_lambda_func-jw" {
filename                       = "${path.module}/python/hello-python.zip"
function_name                  = "weather_retrieve"
role                           = aws_iam_role.lambda_role-jw.arn
handler                        = "index.lambda_handler"
runtime                        = "python3.8"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role-jw]

  environment {
    variables = {
      FILES_TO_WORKFLOW_MAPPING_TABLE = "${var.s3_bucket}}"
   }
}
}

resource "aws_iam_role" "lambda_role-jw" {
name   = "${var.lambda_name}_role-jw"
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

resource "aws_iam_policy" "iam_policy_for_lambda-jw" {
 
 name         = "aws_iam_policy_for_terraform_aws_lambda_role-jw"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
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
   },
   {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListObjects",
                "s3:ListObjectsV2",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket}",
                "arn:aws:s3:::${var.s3_bucket}/*"
            ]
        }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role-jw" {
 role        = aws_iam_role.lambda_role-jw.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda-jw.arn
}

data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/hello-python.zip"
}