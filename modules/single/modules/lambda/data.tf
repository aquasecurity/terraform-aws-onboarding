# modules/single/modules/lambda/data.tf

# Archive generate_external_id.py into a zip file
data "archive_file" "generate_external_id_function" {
  type        = "zip"
  source_file = "${path.module}/functions/generate_external_id.py"
  output_path = "generate_external_id.zip"
}


