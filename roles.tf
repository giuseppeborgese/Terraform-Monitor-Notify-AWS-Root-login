resource "aws_cloudwatch_log_group" "CloudTrailAnalysis" {
  name = "CloudTrailAnalysis"
}

resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "allow_stream_policy" {
  name = "allow_stream_change"
  role = "${aws_iam_role.cloudtrail_role.id}"

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
              ],
              "Resource": [
                "${aws_cloudwatch_log_group.CloudTrailAnalysis.arn}"
              ]
          }
      ]
}
EOF
}

resource "aws_sns_topic" "root_login_notification" {
  name = "RootNotification"
  provisioner "local-exec" {
    command = "aws sns subscribe --region ${var.region} --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.notificationemail}"
  }
}

variable "thiseventname" { default = "LoginRootAccount"}
variable "thisnamespace" { default = "CloudTrailMetrics"}
resource "aws_cloudwatch_log_metric_filter" "rootEvent" {
  name           = "Root_Account_Login"
  pattern        = <<EOF
{ ($.eventSource = "signin.amazonaws.com" ) && ( $.userIdentity.type = "Root" ) }
EOF
  log_group_name = "${aws_cloudwatch_log_group.CloudTrailAnalysis.name}"

  metric_transformation {
    name      = "${var.thiseventname}"
    namespace = "${var.thisnamespace}"
    value     = "1"
  }
}

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}

resource "aws_cloudwatch_metric_alarm" "rootAlarm" {
  alarm_name          = "Root_Account_Login"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.thiseventname}"
  namespace           = "${var.thisnamespace}"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"

  alarm_description = "in the AWS account with id = ${data.aws_caller_identity.current.account_id} and alias = ${data.aws_iam_account_alias.current.account_alias} the root user logged in"
  alarm_actions     = ["${aws_sns_topic.root_login_notification.arn}"]
}
