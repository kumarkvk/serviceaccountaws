
# main.tf

# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Use your desired region

  assume_role {
    role_arn = "arn:aws:iam::622385389008:role/role-destination-recommender-agent"
  }
}

# Create an IAM Role following the naming conventions
resource "aws_iam_role" "agent_role" {
  name               = "agent-${var.sam_app_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::622385898:user/svc-destination-recommender-agent"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  permissions_boundary = "arn:aws:iam::622385389008:policy/custom-DeveloperRoleBoundary"
}

# Output the ARN of the created role
output "agent_role_arn" {
  value = aws_iam_role.agent_role.arn
}

# Set a variable for the SAM application name
variable "sam_app_name" {
  default = "my-sam-application"
}


# Define the AWS CloudFormation resource
resource "aws_cloudformation_stack" "sam_application" {
  name         = "my-sam-application-stack"
  template_body = file("${path.module}/template.yaml")
  parameters = {
    # Add necessary parameters for your SAM application
  }

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  # Use resource-based policy to assume an IAM Role
  stack_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::622385389008:role/aws-service-role/sam.amazonaws.com/AWSServiceRoleForSAM"
      }
      Action = "sts:AssumeRole"
    }]
  })

  # Use the role ARN as profile to deploy SAM
  profile = aws_iam_role.agent_role.name
}

