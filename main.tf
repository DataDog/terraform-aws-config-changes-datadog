resource "aws_config_configuration_recorder" "config_stream_recorder" {
  role_arn = aws_iam_role.config_stream_role.arn
  recording_group {
    all_supported = true
  }
  recording_mode {
    recording_frequency = "CONTINUOUS"
  }
}

resource "aws_config_delivery_channel" "config_stream_delivery_channel" {
  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }
  s3_bucket_name = aws_s3_bucket.config_stream_bucket.id
  sns_topic_arn  = aws_sns_topic.aws_config_stream_topic.id
  depends_on     = [aws_config_configuration_recorder.config_stream_recorder]
}

resource "aws_config_configuration_recorder_status" "config_stream_delivery_status_manager" {
  name       = aws_config_configuration_recorder.config_stream_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_stream_delivery_channel]
}

resource "aws_sns_topic" "aws_config_stream_topic" {
  name = var.sns_topic_name
  tags = local.tags
}

resource "aws_s3_bucket" "config_stream_bucket" {
  bucket = var.s3_bucket_name
  tags   = local.tags
}

resource "aws_sns_topic_subscription" "config_stream_subscription" {
  protocol              = "firehose"
  topic_arn             = aws_sns_topic.aws_config_stream_topic.id
  endpoint              = aws_kinesis_firehose_delivery_stream.config_delivery_stream.arn
  subscription_role_arn = aws_iam_role.config_stream_subscription_role.arn
}

resource "aws_s3_bucket" "failed_events_config_bucket" {
  bucket = var.failed_events_s3_bucket_name
  tags   = local.tags
}

resource "aws_kinesis_firehose_delivery_stream" "config_delivery_stream" {
  name        = "ConfigChangesStream"
  destination = "http_endpoint"
  http_endpoint_configuration {
    name               = "datadog config stream intake"
    url                = var.dd_destination_url
    buffering_size     = 4
    buffering_interval = 10
    role_arn           = aws_iam_role.config_stream_delivery_role.arn
    s3_backup_mode     = "FailedDataOnly"

    s3_configuration {
      bucket_arn         = aws_s3_bucket.failed_events_config_bucket.arn
      role_arn           = aws_iam_role.config_stream_delivery_role.arn
      buffering_size     = 4
      buffering_interval = 400
      cloudwatch_logging_options {
        enabled         = true
        log_group_name  = aws_cloudwatch_log_group.config_delivery_stream_log_group.name
        log_stream_name = aws_cloudwatch_log_stream.config_delivery_log_stream.name
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.config_delivery_stream_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.config_delivery_log_stream.name
    }

    request_configuration {
      content_encoding = "GZIP"
      common_attributes {
        name  = "dd-s3-bucket-auth-account-id"
        value = var.aws_account_id == null ? data.aws_caller_identity.current.account_id : var.aws_account_id
      }
    }

    secrets_manager_configuration {
      enabled    = true
      secret_arn = var.dd_api_key_secret_arn
      role_arn   = aws_iam_role.config_stream_delivery_role.arn
    }
  }
  tags = local.tags
}

resource "aws_cloudwatch_log_group" "config_delivery_stream_log_group" {
  name              = "/aws/kinesisfirehose/configchangesdeliverystream"
  retention_in_days = 30
  tags              = local.tags
}

resource "aws_cloudwatch_log_stream" "config_delivery_log_stream" {
  name           = "ConfigDeliveryLogStream"
  log_group_name = aws_cloudwatch_log_group.config_delivery_stream_log_group.name
}
