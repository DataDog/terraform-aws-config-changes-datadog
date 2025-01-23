resource "aws_iam_role_policy" "config_stream_role_policy" {
  name = "WriteConfigChangePolicy"
  role = aws_iam_role.config_stream_role.id
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "sns:Publish"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:${var.sns_topic_name}"
        ]
      },
      {
        "Action" : [
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:s3:::${var.s3_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
      }
    ],
    "Version" : "2012-10-17"
  })
}

resource "aws_iam_role_policy" "config_stream_subscription_role_policy" {
  name = "WriteToConfigDataStream"
  role = aws_iam_role.config_stream_subscription_role.id
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "firehose:DescribeDeliveryStream",
          "firehose:ListDeliveryStreams",
          "firehose:ListTagsForDeliveryStream",
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:firehose:*:${data.aws_caller_identity.current.account_id}:deliverystream/ConfigChangesStream"
      }
    ],
    "Version" : "2012-10-17"
  })
}

resource "aws_iam_role_policy" "config_stream_delivery_role_policy" {
  name = "DeliveryStreamRolePolicy"
  role = aws_iam_role.config_stream_delivery_role.id
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/kinesisfirehose/configchangesdeliverystream:log-stream:*"
      },
      {
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::${var.failed_events_s3_bucket_name}",
          "arn:aws:s3:::${var.failed_events_s3_bucket_name}/*"
        ]
      },
      {
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Effect" : "Allow",
        "Resource" : var.dd_api_key_secret_arn
      }
    ],
    "Version" : "2012-10-17"
  })
}

resource "aws_iam_role_policy" "config_stream_bucket_read_policy" {
  name = "ReadConfigBucketPolicy"
  role = var.dd_integration_role_name
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "s3:GetObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ],
    "Version" : "2012-10-17"
  })
}
