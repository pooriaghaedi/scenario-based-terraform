resource "aws_cloudwatch_event_rule" "schedule" {
  name                = local.function_name
  description         = "Run Lambda Function on 15 minute basis"
  schedule_expression = "cron(0/15 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "example" {
  arn  = aws_lambda_function.example.arn
  rule = aws_cloudwatch_event_rule.schedule.arn

  input_transformer {
    input_paths = {
      name = "$.detail.name",
      age   = "$.detail.age",
    }
    input_template = <<EOF
{
    "What is your name?": <name>,
    "How old are you?": <age>
}
EOF
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    effect  = "Allow"
    actions = ["lambda:InvokeFunction"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_cloudwatch_event_rule.schedule.arn]
  }
}
