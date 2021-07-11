variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PHONE_NUMBER" {
  type = string
}

variable "LAMBDA_CRON_EXPRESSION" {
  # default = "cron(0/1 * ? * * *)" # for testing: once every minute
  default = "cron(0 21 ? * * *)"
}
