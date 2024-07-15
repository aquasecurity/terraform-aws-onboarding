# modules/single/modules/lambda/data.tf

# Archive create_cspm_key.py into a zip file
data "archive_file" "create_cspm_key_function" {
  type        = "zip"
  source_file = "${path.module}/functions/create_cspm_key.py"
  output_path = "create_cspm_key.zip"
}

# Archive generate_external_id.py into a zip file
data "archive_file" "generate_external_id_function" {
  type        = "zip"
  source_file = "${path.module}/functions/generate_external_id.py"
  output_path = "generate_external_id.zip"
}


