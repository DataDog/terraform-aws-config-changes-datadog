# AWS Config Change Streaming Module

## Description
Use thie Terraform module to Enable AWS Config configuration changes streaming to Datadog.  
This module will create and enable an AWS configuration recorder [see here](https://docs.aws.amazon.com/config/)
which records all resource configuration changes applied to any AWS resource and forwards them to Datadog.  
For further info check [Datadog Official Documentation](https://docs.datadoghq.com/integrations/amazon_config)

## Requirements 
| Name | Version |
|  :--:  |    :--:   |
| [terraform](https://github.com/hashicorp/terraform/releases/tag/v1.8.4) | >= 1.8.4 |
| [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) | >= 4.5.0 |

## Input

| Parameter | Type | Required | Default value | Description |
|--|:--:|:--:|:--:|--|
| `aws_account_id` | `string` | No | Caller Identity | AWS Account ID. Will be used to add a custom header when streaming config changes to Datadog. The account ID will be used to authenticate and authorize the request to read config changes from AWS Config S3 bucket. Account ID can be found [here](https://app.datadoghq.com/account/settings#integrations/aws). |
| `dd_integration_role_name` | `string` | Yes | Empty | Datadog's AWS IAM Integration Role name. The integration role policy will be amended to grant Datadog read permissions on a S3 bucket that will store oversized AWS Config events which can't be streamed via Kinesis Firehose. |
| `dd_api_key_secret_arn` | `string` | Yes | Empty | Datadog API key secret ARN. Check [this page](https://docs.aws.amazon.com/firehose/latest/dev/create-destination.html#create-destination-datadog) for more about configuring AWS Firehose destination for Datadog. Check [this page](https://docs.aws.amazon.com/firehose/latest/dev/secrets-manager-whats-secret.html) to undersatnd the secret's JSON format. |
| `dd_destination_url` | `string` | Yes | `https://cloudplatform-intake.datadoghq.com/api/v2/cloudchanges?dd-protocol=aws-kinesis-firehose` | Datadog intake URL which receives configuration changes. There's a different intake URL per datacenter (DC), check the different URLs (DC) [here](https://docs.datadoghq.com/integrations/amazon_config/?tab=manual#create-an-amazon-data-firehose-stream).|
| `failed_events_s3_bucket_name` | `string` | Yes | Empty | A backup S3 bucket name which stores events that failed to be sent to Datadog. |
| `s3_bucket_name` | `string` | Yes | Empty | AWS Config changes S3 bucket name. |
| `sns_topic_name` | `string` | Yes | Empty | AWS Config changes SNS topic name. |
| `tags` | `map(string)` | No | Empty | Optional tags to attach to the created resources. |


## Output

| Name | Description |
|------|-------------|
| [AWS Config S3 bucket ARN](#output\_config\_change\_bucket\_arn) | S3 bucket which stores configuration changes. |
| [AWS Config backup S3 bucket ARN](#output\_failed\_events\_bucket\_arn) | S3 bucket which stores configuration changes that failed to be sent to Datadog. |
| [AWS Config SNS topic ARN](#output\_config\_change\_topic\_arn) | SNS topic which tunnels configuration changes to Firehose. |
| [AWS Firehose data stream ARN](#output\_config\_change\_stream\_arn) | Kinesis Firehose data stream which sends configuration changes to Datadog. |
| [AWS Firehose Cloudwatch log group](#output\_config\_change\_stream\_log\_group) | Cloudwatch log group for Kinesis Firehose logs. |



