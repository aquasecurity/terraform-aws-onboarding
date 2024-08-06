# modules/single/modules/kinesis/main.tf

# Create Cloudwatch event bus
resource "aws_cloudwatch_event_bus" "event_bus" {
  name = "aqua-bus-${var.random_id}"
}

# Create Cloudwatch event rule for EBS events
resource "aws_cloudwatch_event_rule" "event_rule" {
  name           = "aqua-autoconnect-event-rule-${var.random_id}"
  description    = "Aqua EventBridge rule"
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
  role_arn       = aws_iam_role.kinesis_stream_events_role.arn
  event_pattern = jsonencode({
    "detail" : {
      "event" : [
        "createSnapshots"
      ],
      "result" : [
        "succeeded",
        "failed"
      ]
    },
    "detail-type" : [
      "EBS Multi-Volume Snapshots Completion Status"
    ],
    "source" : [
      "aws.ec2"
    ]
  })
}

# Create Kinesis Processor lambda Cloudwatch log group
# trivy:ignore:AVD-AWS-0017
resource "aws_cloudwatch_log_group" "kinesis_processor_lambda_log_group" {
  name              = "/aws/lambda/aqua-autoconnect-kinesis-processor-lambda-${var.random_id}"
  retention_in_days = 7
}

# Create Kinesis Data Stream Events role
resource "aws_iam_role" "kinesis_stream_events_role" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  inline_policy {
    name = "kinesis-datastream-events-role-policy-${var.random_id}"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "kinesis:PutRecord",
            "kinesis:PutRecords"
          ],
          "Resource" : aws_kinesis_stream.kinesis_stream.arn,
          "Effect" : "Allow"
        }
      ]
    })
  }
  name = "aqua-autoconnect-kinesis-datastream-events-role-${var.random_id}"
}

# Create Kinesis Firehose role
resource "aws_iam_role" "kinesis_firehose_role" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "firehose.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  description = "Aqua kinesis firehose role"
  inline_policy {
    name = "aqua-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "kinesis:DescribeStream",
            "kinesis:GetRecords",
            "kinesis:GetShardIterator",
            "kinesis:ListShards"
          ],
          "Resource" : aws_kinesis_stream.kinesis_stream.arn,
          "Effect" : "Allow",
          "Sid" : "kinesisStreamPermissions"
        },
        {
          "Action" : [
            "lambda:GetFunctionConfiguration",
            "lambda:InvokeFunction"
          ],
          "Resource" : aws_kinesis_stream.kinesis_stream.arn,
          "Effect" : "Allow",
          "Sid" : "lambdaPermissions"
        },
        {
          "Action" : [
            "s3:AbortMultipartUpload",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
          ],
          "Resource" : [
            aws_s3_bucket.kinesis_firehose_bucket.arn,
            "${aws_s3_bucket.kinesis_firehose_bucket.arn}/*"
          ],
          "Effect" : "Allow",
          "Sid" : "s3Permissions"
        }
      ]
    })
  }
  name = "aqua-autoconnect-kinesis-firehose-role-${var.random_id}"
}

# Create Kinesis Processor lambda execution role
resource "aws_iam_role" "processor_lambda_execution_role" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  description = "Aqua kinesis firehose processor lambda role"
  inline_policy {
    name = "policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "ec2:DescribeSnapshots",
          "Resource" : "*",
          "Effect" : "Allow",
          "Sid" : "DescribeEc2Snapshots"
        }
      ]
    })
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
  name                = var.custom_processor_lambda_role_name == "" ? "aqua-autoconnect-processor-lambda-execution-role-${var.random_id}" : var.custom_processor_lambda_role_name
}

# Create Kinesis Firehose S3 bucket
# trivy:ignore:AVD-AWS-0090
# trivy:ignore:AVD-AWS-0089
resource "aws_s3_bucket" "kinesis_firehose_bucket" {
  bucket = var.custom_bucket_name == "" ? "aqua-autoconnect-kinesis-firehose-bucket-${var.random_id}" : var.custom_bucket_name
}

# Create Kinesis Firehose S3 bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "kinesis_firehose_bucket" {
  bucket = aws_s3_bucket.kinesis_firehose_bucket.bucket
  rule {
    expiration {
      days                         = 7
      expired_object_delete_marker = false
    }
    id     = "aqua-autoconnect-kinesis-firehose-bucket-lifecycle-policy"
    status = "Enabled"
  }
}

# Create Kinesis Firehose S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "kinesis_firehose_bucket" {
  bucket                  = aws_s3_bucket.kinesis_firehose_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create Kinesis Firehose S3 bucket SSE configuration
# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket_server_side_encryption_configuration" "kinesis_firehose_bucket" {
  bucket = aws_s3_bucket.kinesis_firehose_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}

# Create Kinesis Processor lambda function
# trivy:ignore:AVD-AWS-0066
resource "aws_lambda_function" "kinesis_processor_lambda" {
  architectures    = ["x86_64"]
  description      = "Aqua Kinesis Firehose Processor Lambda"
  function_name    = "aqua-autoconnect-kinesis-processor-lambda-function-${var.random_id}"
  handler          = "index.handler"
  role             = aws_iam_role.processor_lambda_execution_role.arn
  runtime          = "python3.12"
  timeout          = 900
  filename         = data.archive_file.kinesis_processor_function.output_path
  source_code_hash = data.archive_file.kinesis_processor_function.output_base64sha256
  tracing_config {
    mode = "PassThrough"
  }
}

# Create Kinesis Stream
resource "aws_kinesis_stream" "kinesis_stream" {
  encryption_type = "KMS"
  kms_key_id      = "alias/aws/kinesis"
  name            = "aqua-autoconnect-kinesis-datastream-${var.random_id}"
  shard_count     = 1
}

# Create Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose" {
  destination = "http_endpoint"
  http_endpoint_configuration {
    access_key         = var.aqua_volscan_api_token
    buffering_interval = 60
    buffering_size     = 5
    name               = "kinesis-firehose-destination"
    processing_configuration {
      enabled = true
      processors {
        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = aws_lambda_function.kinesis_processor_lambda.arn
        }
        type = "Lambda"
      }
    }
    role_arn = aws_iam_role.kinesis_firehose_role.arn
    url      = var.aqua_volscan_api_url
    s3_configuration {
      bucket_arn = aws_s3_bucket.kinesis_firehose_bucket.arn
      role_arn   = aws_iam_role.kinesis_firehose_role.arn
    }
  }
  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.kinesis_stream.arn
    role_arn           = aws_iam_role.kinesis_firehose_role.arn
  }
  name = "aqua-autoconnect-kinesis-firehose-${var.random_id}"
}

