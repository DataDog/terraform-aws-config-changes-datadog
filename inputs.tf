variable "aws_account_id" {
  description = "AWS account ID."
  type        = string
  default     = null
}

variable "dd_api_key_secret_arn" {
  type        = string
  description = "AWS Secret ARN which contains Datadog's API key."
  sensitive   = true
  default     = ""
  validation {
    condition     = var.dd_api_key_secret_arn != ""
    error_message = "Datadog API key secret ARN is required."
  }
}

variable "dd_integration_role_name" {
  type        = string
  description = "Datadog integration role name."
  default     = ""
  validation {
    condition     = try(regex("^[A-Za-z0-9_+=,.@-]+$", var.dd_integration_role_name), null) == null ? false : true
    error_message = "Datadog integration role name does not match the allowed pattern."
  }
}


variable "dd_destination_url" {
  description = "Datadog intake URL."
  type        = string
  default     = "https://cloudplatform-intake.datadoghq.com/api/v2/cloudchanges?dd-protocol=aws-kinesis-firehose"
  validation {
    condition = contains(["https://cloudplatform-intake.datadoghq.com/api/v2/cloudchanges?dd-protocol=aws-kinesis-firehose",
      "https://cloudplatform-intake.ap1.datadoghq.com/api/v2/cloudchanges?dd-protocol=aws-kinesis-firehose",
      "https://cloudplatform-intake.datadoghq.eu/api/v2/cloudchanges?dd-protocol=aws-kinesis-firehose",
      "https://cloudplatform-intake.us3.datadoghq.com/api/v2/cloudchanges?dd-protocol=aws-kinesis-firehose",
    "https://cloudplatform-intake.us5.datadoghq.com/api/v2/cloudchanges?dd-protocol=aws-kinesis-firehose"], var.dd_destination_url)
    error_message = "Destination URL must be a known option"
  }
}

variable "failed_events_s3_bucket_name" {
  description = "Backup S3 bucket name for Kinesis Firehose"
  type        = string
  default     = ""
  validation {
    condition     = length(var.failed_events_s3_bucket_name) > 3 && length(var.failed_events_s3_bucket_name) < 64
    error_message = "Bucket name must be between 3 and 63 characters long."
  }
  validation {
    condition     = try(regex("[^a-z0-9.-]", var.failed_events_s3_bucket_name), null) == null ? true : false
    error_message = "Bucket name can consist only of lowercase letters, numbers, dots `.`, and hyphens `-`."
  }
  validation {
    condition     = try(regex("^xn--", var.failed_events_s3_bucket_name), null) == null ? true : false
    error_message = "Bucket name must not start with the prefix `xn--`."
  }
  validation {
    condition     = try(regex("^[a-z0-9]", var.failed_events_s3_bucket_name), null) == null ? false : true
    error_message = "Bucket name must begin with a letter or number."
  }
  validation {
    condition     = try(regex("[a-z0-9]$", var.failed_events_s3_bucket_name), null) == null ? false : true
    error_message = "Bucket name must end with a letter or number."
  }
  validation {
    condition     = try(regex("[0-9]*[.][0-9]*[.][0-9]*[.][0-9]*", var.failed_events_s3_bucket_name), null) == null ? true : false
    error_message = "Bucket name must not be formatted as an IP address (for example, 192.168.5.4)."
  }
  validation {
    condition     = try(regex("-s3alias$", var.failed_events_s3_bucket_name), null) == null ? true : false
    error_message = "Bucket name must not end with the suffix `-s3alias`."
  }
}

variable "s3_bucket_name" {
  description = "S3 bucket name for AWS Config."
  type        = string
  default     = ""
  validation {
    condition     = length(var.s3_bucket_name) > 3 && length(var.s3_bucket_name) < 64
    error_message = "Bucket name must be between 3 and 63 characters long."
  }
  validation {
    condition     = try(regex("[^a-z0-9.-]", var.s3_bucket_name), null) == null ? true : false
    error_message = "Bucket name can consist only of lowercase letters, numbers, dots `.`, and hyphens `-`."
  }
  validation {
    condition     = try(regex("^xn--", var.s3_bucket_name), null) == null ? true : false
    error_message = "Bucket name must not start with the prefix `xn--`."
  }
  validation {
    condition     = try(regex("^[a-z0-9]", var.s3_bucket_name), null) == null ? false : true
    error_message = "Bucket name must begin with a letter or number."
  }
  validation {
    condition     = try(regex("[a-z0-9]$", var.s3_bucket_name), null) == null ? false : true
    error_message = "Bucket name must end with a letter or number."
  }
  validation {
    condition     = try(regex("[0-9]*[.][0-9]*[.][0-9]*[.][0-9]*", var.s3_bucket_name), null) == null ? true : false
    error_message = "Bucket name must not be formatted as an IP address (for example, 192.168.5.4)."
  }
  validation {
    condition     = try(regex("-s3alias$", var.s3_bucket_name), null) == null ? true : false
    error_message = "Bucket name must not end with the suffix `-s3alias`."
  }
}

variable "sns_topic_name" {
  description = "AWS Config SNS topic name"
  type        = string
  default     = ""
  validation {
    condition     = var.sns_topic_name != ""
    error_message = "AWS Config SNS topic name is required."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
