# modules/single/modules/lambda/main.tf

# Create lambda execution role
resource "aws_iam_role" "lambda_execution_role" {
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
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  name                = "aqua-autoconnect-lambda-execution-role-${var.random_id}"
}

# Create CSPM lambda execution role
resource "aws_iam_role" "cspm_lambda_execution_role" {
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
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  name                = "aqua-autoconnect-cspm-lambda-execution-role-${var.random_id}"
}

# Create generate Volume Scan external id lambda function
resource "aws_lambda_function" "generate_volscan_external_id_function" {
  count            = var.create_vol_scan_resource ? 1 : 0
  architectures    = ["x86_64"]
  description      = "Generate Volume Scanning External ID"
  function_name    = "aqua-autoconnect-generate-volscan-external-id-function-${var.random_id}"
  handler          = "generate_external_id.handler"
  role             = aws_iam_role.cspm_lambda_execution_role.arn
  runtime          = "python3.12"
  timeout          = 120
  filename         = data.archive_file.generate_external_id_function.output_path
  source_code_hash = data.archive_file.generate_external_id_function.output_base64sha256
  tracing_config {
    mode = "Active"
  }
}

# Invoking generate Volume Scan external id lambda function
resource "aws_lambda_invocation" "generate_volscan_external_id_function" {
  count         = var.create_vol_scan_resource ? 1 : 0
  function_name = aws_lambda_function.generate_volscan_external_id_function[0].function_name
  input = jsonencode({
    ApiUrl            = var.aqua_cspm_url
    AutoConnectApiUrl = var.aqua_autoconnect_url
    AquaApiKey        = var.aqua_api_key
    AquaSecretKey     = var.aqua_api_secret
  })
  triggers = {
    always_run = timestamp()
  }
}

# Create generate CSPM external id lambda function
resource "aws_lambda_function" "generate_cspm_external_id_function" {
  architectures    = ["x86_64"]
  description      = "Generate CSPM External ID"
  function_name    = "aqua-autoconnect-generate-cspm-external-id-function-${var.random_id}"
  handler          = "generate_external_id.handler"
  role             = aws_iam_role.cspm_lambda_execution_role.arn
  runtime          = "python3.12"
  timeout          = 120
  filename         = data.archive_file.generate_external_id_function.output_path
  source_code_hash = data.archive_file.generate_external_id_function.output_base64sha256
  tracing_config {
    mode = "Active"
  }
}

# Invoking generate CSPM external id lambda function
resource "aws_lambda_invocation" "generate_cspm_external_id_function" {
  function_name = aws_lambda_function.generate_cspm_external_id_function.function_name
  input = jsonencode({
    ApiUrl            = var.aqua_cspm_url
    AutoConnectApiUrl = var.aqua_autoconnect_url
    AquaApiKey        = var.aqua_api_key
    AquaSecretKey     = var.aqua_api_secret
  })
  triggers = {
    always_run = timestamp()
  }
}

# Create Agentless role
# trivy:ignore:AVD-AWS-0057
resource "aws_iam_role" "agentless_role" {
  count = var.create_vol_scan_resource ? 1 : 0
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.aqua_volscan_aws_account_id}:root"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : local.volscan_external_id
          }
        }
      }
    ]
  })
  description = "Aqua Agentless Role"
  inline_policy {
    name = "policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ec2:CreateSnapshot",
            "ec2:CreateSnapshots",
            "ec2:CreateVolume",
            "ec2:DescribeInstances",
            "ec2:DescribeRegions",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSnapshots",
            "ec2:DescribeSubnets",
            "ec2:DescribeVolumes",
            "ec2:RunInstances"
          ],
          "Resource" : "*",
          "Effect" : "Allow",
          "Sid" : "createEc2Resources"
        },
        {
          "Condition" : {
            "StringLike" : {
              "ec2:ResourceTag/aqua-agentless-scanner" : "*"
            }
          },
          "Action" : [
            "ec2:DeleteSnapshot",
            "ec2:DeleteVolume",
            "ec2:TerminateInstances"
          ],
          "Resource" : "*",
          "Effect" : "Allow",
          "Sid" : "deleteEc2Resources"
        },
        {
          "Condition" : {
            "StringEquals" : {
              "ec2:CreateAction" : [
                "CreateSnapshot",
                "CreateSnapshots",
                "CreateVolume",
                "RunInstances"
              ]
            }
          },
          "Action" : "ec2:CreateTags",
          "Resource" : "*",
          "Effect" : "Allow",
          "Sid" : "createEc2Tags"
        },
        {
          "Action" : [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ],
          "Resource" : "*",
          "Effect" : "Allow",
          "Sid" : "AllowKMS"
        }
      ]
    })
  }
  name       = var.custom_agentless_role_name == "" ? "aqua-agentless-role-${var.random_id}" : var.custom_agentless_role_name
  depends_on = [aws_lambda_invocation.generate_volscan_external_id_function[0]]
}

# Create CSPM role
# trivy:ignore:AVD-AWS-0057
resource "aws_iam_role" "cspm_role" {
  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.aqua_cspm_aws_account_id}:role/${var.aqua_cspm_role_prefix}lambda-cloudsploit-api"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : local.cspm_external_id
          },
          "IpAddress" : {
            "aws:SourceIp" : var.aqua_cspm_ipv4_address
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.aqua_cspm_aws_account_id}:role/${var.aqua_cspm_role_prefix}lambda-cloudsploit-collector"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : local.cspm_external_id
          },
          "IpAddress" : {
            "aws:SourceIp" : var.aqua_cspm_ipv4_address
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.aqua_cspm_aws_account_id}:role/${var.aqua_cspm_role_prefix}lambda-cloudsploit-remediator"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : local.cspm_external_id
          },
          "IpAddress" : {
            "aws:SourceIp" : var.aqua_cspm_ipv4_address
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.aqua_cspm_aws_account_id}:role/${var.aqua_cspm_role_prefix}lambda-cloudsploit-tasks"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : local.cspm_external_id
          },
          "IpAddress" : {
            "aws:SourceIp" : var.aqua_cspm_ipv4_address
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : var.aqua_worker_role_arn
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  inline_policy {
    name = "aqua-csp-scanner-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:GetAuthorizationToken",
            "lambda:ListAliases",
            "lambda:ListTags",
            "lambda:GetLayerVersion",
            "lambda:UntagResource",
            "lambda:PutFunctionConcurrency",
            "lambda:TagResource",
            "lambda:GetFunction",
            "lambda:UpdateFunctionConfiguration",
            "lambda:PublishLayerVersion",
            "lambda:DeleteLayerVersion",
            "lambda:DeleteFunctionConcurrency",
            "iam:ListRolePolicies",
            "cloudwatch:GetMetricData",
            "cloudwatch:ListMetrics"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    })
  }
  inline_policy {
    name = "aqua-cspm-supplemental-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "compute-optimizer:GetEC2InstanceRecommendations",
            "compute-optimizer:GetAutoScalingGroupRecommendations",
            "imagebuilder:ListInfrastructureConfigurations",
            "imagebuilder:ListImageRecipes",
            "imagebuilder:ListContainerRecipes",
            "imagebuilder:ListComponents",
            "imagebuilder:GetComponent",
            "ses:DescribeActiveReceiptRuleSet",
            "athena:GetWorkGroup",
            "logs:DescribeLogGroups",
            "logs:DescribeMetricFilters",
            "config:getComplianceDetailsByConfigRule",
            "elasticmapreduce:ListInstanceGroups",
            "elastictranscoder:ListPipelines",
            "elasticfilesystem:DescribeFileSystems",
            "servicequotas:ListServiceQuotas",
            "ssm:ListAssociations",
            "devops-guru:ListNotificationChannels",
            "ec2:GetEbsEncryptionByDefault",
            "ec2:GetEbsDefaultKmsKeyId",
            "organizations:ListAccounts",
            "kendra:ListIndices",
            "proton:ListEnvironmentTemplates",
            "qldb:ListLedgers",
            "airflow:ListEnvironments",
            "airflow:GetEnvironment",
            "profile:ListDomains",
            "timestream:DescribeEndpoints",
            "timestream:ListDatabases",
            "frauddetector:GetDetectors",
            "memorydb:DescribeClusters",
            "kafka:ListClusters",
            "apprunner:ListServices",
            "apprunner:DescribeService",
            "finspace:ListEnvironments",
            "healthlake:ListFHIRDatastores",
            "codeartifact:ListDomains",
            "auditmanager:GetSettings",
            "appflow:ListFlows",
            "databrew:ListJobs",
            "managedblockchain:ListNetworks",
            "managedblockchain:ListMembers",
            "managedblockchain:GetMember",
            "connect:ListInstances",
            "backup:ListBackupVaults",
            "backup:DescribeRegionSettings",
            "backup:getBackupVaultNotifications",
            "backup:ListBackupPlans",
            "backup:GetBackupVaultAccessPolicy",
            "backup:GetBackupPlan",
            "dlm:GetLifecyclePolicies",
            "glue:GetSecurityConfigurations",
            "ssm:describeSessions",
            "ssm:GetServiceSetting",
            "ecr:DescribeRegistry",
            "ecr-public:DescribeRegistries",
            "kinesisvideo:ListStreams",
            "wisdom:ListAssistants",
            "voiceid:ListDomains",
            "lookoutequipment:ListDatasets",
            "iotsitewise:DescribeDefaultEncryptionConfiguration",
            "geo:ListTrackers",
            "geo:ListGeofenceCollections",
            "lookoutvision:ListProjects",
            "lookoutmetrics:ListAnomalyDetectors",
            "lex:ListBots",
            "forecast:ListDatasets",
            "forecast:ListForecastExportJobs",
            "forecast:DescribeDataset",
            "lambda:GetFunctionUrlConfig",
            "lambda:GetFunctionCodeSigningConfig",
            "cloudwatch:GetMetricStatistics",
            "geo:DescribeTracker",
            "connect:ListInstanceStorageConfigs",
            "lex:ListBotAliases",
            "lookoutvision:ListModels",
            "geo:DescribeGeofenceCollection",
            "codebuild:BatchGetProjects",
            "profile:GetDomain",
            "lex:DescribeBotAlias",
            "lookoutvision:DescribeModel",
            "s3:ListBucket",
            "frauddetector:GetKMSEncryptionKey",
            "imagebuilder:ListImagePipelines",
            "compute-optimizer:GetRecommendationSummaries",
            "wafv2:GetWebACLForResource",
            "appflow:DescribeFlow",
            "aoss:ListSecurityPolicies",
            "aoss:GetAccessPolicy",
            "aoss:ListCollections",
            "aoss:ListAccessPolicies",
            "aoss:GetSecurityPolicy",
            "cognito-idp:GetWebACLForResource",
            "cognito-idp:ListResourcesForWebACL",
            "bedrock:ListCustomModels",
            "bedrock:GetModelInvocationLoggingConfiguration",
            "bedrock:ListModelCustomizationJobs",
            "bedrock:GetCustomModel",
            "bedrock:GetModelCustomizationJob"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "apigateway:GET"
          ],
          "Resource" : [
            "arn:aws:apigateway:*::/domainnames/*"
          ],
          "Effect" : "Allow"
        },
        {
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::elasticbeanstalk-env-resources-*",
          "Effect" : "Allow"
        }
      ]
    })
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/SecurityAudit"]
  name                = var.custom_cspm_role_name == "" ? "aqua-autoconnect-cspm-role-${var.random_id}" : var.custom_cspm_role_name
}

# Creating a sleep for 30s between CSPM role and CSPM key lambda function
resource "time_sleep" "sleep" {
  create_duration = "30s"
  triggers = {
    cspm_assume_role_policy = aws_iam_role.cspm_role.assume_role_policy
  }
  depends_on = [aws_iam_role.cspm_role]
}

# Create Registry Scanning role
# trivy:ignore:AVD-AWS-0057
resource "aws_iam_role" "registry_scanning_role" {
  count = var.create_registry_scanning_resource ? 1 : 0
  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : var.aqua_worker_role_arn
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  inline_policy {
    name = "aqua-registry-scanning-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:GetRepositoryPolicy",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:DescribeRepositories",
            "ecr:GetAuthorizationToken",
            "iam:ListRolePolicies",
            "cloudwatch:GetMetricData",
            "cloudwatch:ListMetrics"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    })
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/SecurityAudit"]
  name                = var.custom_registry_scanning_role_name == "" ? "aqua-autoconnect-registry-scanning-role-${var.random_id}" : var.custom_registry_scanning_role_name
}

# Create Serverless Scanning role
# trivy:ignore:AVD-AWS-0057
resource "aws_iam_role" "serverless_scanning_role" {
  count = var.create_serverless_scanning_resource ? 1 : 0
  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : var.aqua_worker_role_arn
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  inline_policy {
    name = "aqua-serverless-scanning-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "lambda:ListAliases",
            "lambda:ListTags",
            "lambda:GetLayerVersion",
            "lambda:UntagResource",
            "lambda:PutFunctionConcurrency",
            "lambda:TagResource",
            "lambda:GetFunction",
            "lambda:UpdateFunctionConfiguration",
            "lambda:PublishLayerVersion",
            "lambda:DeleteLayerVersion",
            "lambda:DeleteFunctionConcurrency",
            "lambda:GetFunctionUrlConfig",
            "lambda:GetFunctionCodeSigningConfig",
            "iam:ListRolePolicies",
            "cloudwatch:GetMetricData",
            "cloudwatch:ListMetrics"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    })
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/SecurityAudit"]
  name                = var.custom_serverless_scanning_role_name == "" ? "aqua-autoconnect-serverless-scanning-role-${var.random_id}" : var.custom_serverless_scanning_role_name
}
