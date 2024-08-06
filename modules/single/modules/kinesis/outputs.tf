# modules/single/modules/kinesis/outputs.tf

output "event_bus_arn" {
  description = "Cloudwatch Event Bus ARN"
  value       = aws_cloudwatch_event_bus.event_bus.arn
}

output "event_rule_arn" {
  description = "Cloudwatch Event Rule ARN"
  value       = aws_cloudwatch_event_rule.event_rule.arn
}

output "kinesis_processor_lambda_log_group_name" {
  description = "Kinesis Processor Lambda Cloudwatch Log Group Name"
  value       = aws_cloudwatch_log_group.kinesis_processor_lambda_log_group.name
}

output "kinesis_stream_events_role_arn" {
  description = "Kinesis Stream Events Role ARN"
  value       = aws_iam_role.kinesis_stream_events_role.arn
}

output "kinesis_firehose_role_arn" {
  description = "Kinesis Firehose Role ARN"
  value       = aws_iam_role.kinesis_firehose_role.arn
}

output "kinesis_processor_lambda_execution_role_arn" {
  description = "Kinesis Processor Lambda Execution Role ARN"
  value       = aws_iam_role.processor_lambda_execution_role.arn
}

output "kinesis_firehose_bucket_name" {
  description = "Kinesis Firehose S3 Bucket Name"
  value       = aws_s3_bucket.kinesis_firehose_bucket.bucket
}

output "kinesis_processor_lambda_function_arn" {
  description = "Kinesis Processor Lambda Function ARN"
  value       = aws_lambda_function.kinesis_processor_lambda.arn
}

output "kinesis_stream_arn" {
  description = "Kinesis Stream ARN"
  value       = aws_kinesis_stream.kinesis_stream.arn
}

output "kinesis_firehose_delivery_stream_arn" {
  description = "Kinesis Firehose Delivery Stream ARN"
  value       = aws_kinesis_firehose_delivery_stream.kinesis_firehose.arn
}
