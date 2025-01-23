# aws config changes
resource "aws_iam_role" "config_stream_subscription_role" {
  name = "datadog-config-stream-subscription-role"
  assume_role_policy = jsonencode({
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        }
      }
    ],
    "Version" : "2012-10-17"
    }
  )
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonSNSRole"
  ]
  tags = local.tags
}

resource "aws_iam_role" "config_stream_delivery_role" {
  name = "datadog-config-stream-delivery-role"
  assume_role_policy = jsonencode({
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "firehose.amazonaws.com"
        }
      }
    ],
    "Version" : "2012-10-17"
    }
  )
  tags = local.tags
}

resource "aws_iam_role" "config_stream_role" {
  name = "datadog-config-stream-role"
  assume_role_policy = jsonencode({
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "config.amazonaws.com"
        }
      }
    ],
    "Version" : "2012-10-17"
    }
  )
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
  ]
  tags = local.tags
}
