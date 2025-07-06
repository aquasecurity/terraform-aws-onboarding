# modules/single/modules/kinesis/outputs.tf

output "event_bus_arn" {
  description = "Cloudwatch Event Bus ARN"
  value       = try(aws_cloudwatch_event_bus.event_bus[0].arn, "")
}

output "event_rule_arn" {
  description = "Cloudwatch Event Rule ARN"
  value       = try(aws_cloudwatch_event_rule.event_rule[0].arn, "")
}

output "kinesis_processor_lambda_log_group_name" {
  description = "Kinesis Processor Lambda Cloudwatch Log Group Name"
  value       = try(aws_cloudwatch_log_group.kinesis_processor_lambda_log_group[0].name, "")
}

output "kinesis_stream_events_role_arn" {
  description = "Kinesis Stream Events Role ARN"
  value       = try(aws_iam_role.kinesis_stream_events_role[0].arn, "")
}

output "kinesis_firehose_role_arn" {
  description = "Kinesis Firehose Role ARN"
  value       = try(aws_iam_role.kinesis_firehose_role[0].arn, "")
}

output "kinesis_processor_lambda_execution_role_arn" {
  description = "Kinesis Processor Lambda Execution Role ARN"
  value       = try(aws_iam_role.processor_lambda_execution_role[0].arn, "")
}

output "kinesis_firehose_bucket_name" {
  description = "Kinesis Firehose S3 Bucket Name"
  value       = try(aws_s3_bucket.kinesis_firehose_bucket[0].bucket, "")
}

output "kinesis_processor_lambda_function_arn" {
  description = "Kinesis Processor Lambda Function ARN"
  value       = try(aws_lambda_function.kinesis_processor_lambda[0].arn, "")
}

output "kinesis_stream_arn" {
  description = "Kinesis Stream ARN"
  value       = try(aws_kinesis_stream.kinesis_stream[0].arn, "")
}

output "kinesis_firehose_delivery_stream_arn" {
  description = "Kinesis Firehose Delivery Stream ARN"
  value       = try(aws_kinesis_firehose_delivery_stream.kinesis_firehose[0].arn, "")
}
