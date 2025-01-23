output "config_change_bucket_arn" {
  value = aws_s3_bucket.config_stream_bucket.arn
}

output "failed_events_bucket_arn" {
  value = aws_s3_bucket.failed_events_config_bucket.arn
}

output "config_change_topic_arn" {
  value = aws_sns_topic.aws_config_stream_topic.arn
}

output "config_change_stream_arn" {
  value = aws_kinesis_firehose_delivery_stream.config_delivery_stream.arn
}

output "config_change_stream_log_group" {
  value = aws_cloudwatch_log_group.config_delivery_stream_log_group.arn
}
