

resource "aws_lambda_function" "example" {
  filename = "${local.function_name}.zip"
  function_name = "${local.function_name}"
  role          = aws_iam_role.lambda_cw_logs_role.arn
  timeout       = local.lambda_memory_size
  memory_size   = local.lambda_timeout
  handler       = "main"

  reserved_concurrent_executions = local.lambda_reserved_concurrency
  runtime = local.lambda_runtime
# uncomment following lines if you need an ENV variable
#   environment {
#     variables = {
#       VARIABLE = "Value"
#     }
#   }

 tracing_config {
   mode = "Active"
}

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.my_lambda_logs,
  ]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "my_lambda_logs" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "my_lambda_logs" {
  name        = "${local.function_name}_logging"
  path        = "/"
  description = "IAM policy for ${local.function_name} logging"

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
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_cw_logs_role" {
  name = "${local.function_name}_IAMRole"

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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_cw_logs_role.name
  policy_arn = aws_iam_policy.my_lambda_logs.arn
}


resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn

}
