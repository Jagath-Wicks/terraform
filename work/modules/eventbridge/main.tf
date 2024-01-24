resource "aws_cloudwatch_event_rule" "weather_trigger" {
    name = "weather_trigger"
    schedule_expression = "cron(0 5 * * ? *)"  # to do check if cron job correct
}

resource "aws_cloudwatch_event_target" "weather_retrieve_target" {
    rule = aws_cloudwatch_event_rule.weather_trigger.name
    target_id = "weather_retrieve_target"
    arn = var.lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_retrieval_lambda_target" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.weather_trigger.arn
}

