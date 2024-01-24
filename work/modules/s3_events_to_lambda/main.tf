resource "aws_s3_bucket_notification" "MyS3BucketNotification" {
  bucket      = var.source_bucket
  eventbridge = true
}

resource "aws_cloudwatch_event_rule" "MyEventRule" {
  event_pattern = <<EOF
{
  "detail-type": [
    "Object Created"
  ],
  "source": [
    "aws.s3"
  ],
  "detail": {
    "bucket": {
      "name": ["${var.source_bucket}/*"]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "MyEventRule_target" {
    rule = aws_cloudwatch_event_rule.MyEventRule.name
    target_id = "retrieval_lambda_target"
    arn = var.lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_MyEventRule_target" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.MyEventRule.arn
}
