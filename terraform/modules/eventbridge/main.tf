resource "aws_cloudwatch_event_rule" "this" {
  name                = var.rule_name
  description         = var.rule_description
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "this" {
  rule = aws_cloudwatch_event_rule.this.name
  arn  = var.target_arn
}
