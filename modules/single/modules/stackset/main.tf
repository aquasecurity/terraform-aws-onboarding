# modules/single/modules/stackset/main.tf

# Create Stackset admin role
resource "aws_iam_role" "stackset_admin_role" {
  count = var.create_vol_scan_resource ? 1 : 0
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "cloudformation.eu-south-1.amazonaws.com",
            "cloudformation.amazonaws.com",
            "cloudformation.ap-southeast-3.amazonaws.com",
            "cloudformation.me-south-1.amazonaws.com",
            "cloudformation.ap-east-1.amazonaws.com",
            "cloudformation.af-south-1.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  description = "Aqua StackSet Admin Role"
  inline_policy {
    name = "policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:${var.aws_partition}:iam::*:role/AWSCloudFormationStackSetExecutionRole",
          "Effect" : "Allow"
        }
      ]
    })
  }
  name = "aqua-autoconnect-stackset-admin-role-${var.random_id}"
}

# Create Stackset execution role
# trivy:ignore:AVD-AWS-0057
resource "aws_iam_role" "stackset_execution_role" {
  count = var.create_vol_scan_resource ? 1 : 0
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_iam_role.stackset_admin_role[0].arn
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  description = "Aqua StackSet Execution Role"
  inline_policy {
    name = "policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ec2:CreateInternetGateway",
            "ec2:AttachInternetGateway",
            "ec2:DescribeInternetGateways",
            "ec2:CreateRouteTable",
            "ec2:CreateRoute",
            "ec2:CreateSecurityGroup",
            "ec2:CreateSubnet",
            "ec2:CreateTags",
            "ec2:CreateVpc",
            "ec2:DescribeRouteTables",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcs",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeAccountAttributes",
            "events:DescribeRule",
            "events:EnableRule",
            "events:PutRule",
            "events:PutTargets",
            "iam:CreateRole",
            "iam:GetRolePolicy",
            "iam:GetRole",
            "iam:PassRole",
            "ec2:AssociateRouteTable",
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:DeleteInternetGateway",
            "ec2:DeleteRouteTable",
            "ec2:DeleteRoute",
            "ec2:DeleteSecurityGroup",
            "ec2:DeleteSubnet",
            "ec2:DeleteTags",
            "ec2:DeleteVpc",
            "ec2:DisassociateRouteTable",
            "ec2:ModifySubnetAttribute",
            "ec2:ModifyVpcAttribute",
            "ec2:ReplaceRouteTableAssociation",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:DeleteInternetGateway",
            "ec2:DetachInternetGateway",
            "events:DeleteRule",
            "events:RemoveTargets",
            "iam:DeleteRole",
            "iam:DeleteRolePolicy",
            "iam:PutRolePolicy",
            "iam:TagRole",
            "cloudformation:*",
            "s3:*",
            "sns:*"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    })
  }
  name = "aqua-autoconnect-stackset-execution-role-${var.random_id}"
}

# Create Cloudformation stackset
resource "aws_cloudformation_stack_set" "stack_set" {
  count                   = var.create_vol_scan_resource ? 1 : 0
  name                    = "aqua-autoconnect-stackset-${var.random_id}"
  description             = "Aqua Agentless StackSet"
  permission_model        = "SELF_MANAGED"
  capabilities            = ["CAPABILITY_IAM"]
  administration_role_arn = aws_iam_role.stackset_admin_role[0].arn
  execution_role_name     = aws_iam_role.stackset_execution_role[0].name
  template_url            = "https://${var.aqua_bucket_name}.s3.amazonaws.com/volume-scanning-api-key-cfn-stackset.json"
  operation_preferences {
    region_concurrency_type = "PARALLEL"
    max_concurrent_count    = 1
  }
  parameters = {
    EbBusArn                       = var.event_bus_arn
    CreateVPCs                     = tostring(var.create_vpcs)
    CustomVpcName                  = var.custom_vpc_name
    CustomVpcSubnet1Name           = var.custom_vpc_subnet1_name
    CustomVpcSubnetRouteTable1Name = var.custom_vpc_subnet_route_table1_name
    CustomVpcSubnet2Name           = var.custom_vpc_subnet2_name
    CustomVpcSubnetRouteTable2Name = var.custom_vpc_subnet_route_table2_name
    CustomInternetGatewayName      = var.custom_internet_gateway_name
    CustomSecurityGroupName        = var.custom_security_group_name
  }
}

# Create Cloudformation stackset instance for each enabled region specified
resource "aws_cloudformation_stack_set_instance" "stack_set_instance" {
  for_each       = var.create_vol_scan_resource ? toset(var.enabled_regions) : toset([])
  stack_set_name = aws_cloudformation_stack_set.stack_set[0].name
  account_id     = var.aws_account_id
  region         = each.value
}
