resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

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

resource "aws_iam_policy" "send_sms_policy" {
  name        = "send_sms_policy"
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_send_sms" {
    role = "${aws_iam_role.lambda_role.name}"
    policy_arn = aws_iam_policy.send_sms_policy.arn
}

resource "aws_lambda_function" "sitedownnotifier_lambda" {
  filename      = "lambda_code.zip"
  function_name = "sitedownnotifier"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_script.handler"
  source_code_hash = filebase64sha256("lambda_code.zip")

  runtime = "python3.8"

  environment {
    variables = {
      PHONE_NUMBER = var.PHONE_NUMBER
    }
  }
}
