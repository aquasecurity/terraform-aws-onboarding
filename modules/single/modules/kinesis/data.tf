# modules/single/modules/kinesis/data.tf

# Archive kinesis_processor.py into a zip file
data "archive_file" "kinesis_processor_function" {
  type        = "zip"
  source_file = "${path.module}/functions/kinesis_processor.py"
  output_path = "kinesis_processor.zip"
}