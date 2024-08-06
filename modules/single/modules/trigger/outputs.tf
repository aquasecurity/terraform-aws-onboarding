# modules/single/modules/trigger/outputs.tf

# Onboarding API call output
output "onboarding_status" {
  description = "Onboarding API Status Result"
  value       = data.external.aws_onboarding.result.status
}