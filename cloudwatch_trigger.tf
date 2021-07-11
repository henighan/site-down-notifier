resource "aws_cloudwatch_event_rule" "event_rule" {
  schedule_expression = var.LAMBDA_CRON_EXPRESSION
}

resource "aws_cloudwatch_event_target" "check_at_rate" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  arn = aws_lambda_function.sitedownnotifier_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sitedownnotifier_lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.event_rule.arn
}
