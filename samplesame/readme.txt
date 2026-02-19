
Step 1: Set Environment Variables for AWS Credentials
Set the environment variables for your AWS credentials:

export AWS_ACCESS_KEY_ID="aaaaawdsafdsg"
export AWS_SECRET_ACCESS_KEY="dskjflkhorenv"
Copy
Step 2: Terraform Provider Configuration
Create a file named main.tf:

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

Copy
Step 3: Implement the AWS SAM Application with CloudFormation
Assuming you have a SAM application ready (a template.yaml file), use Terraform to deploy it via an AWS CloudFormation stack. Add these to your main.tf:

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
Copy
Step 4: Initialize One Terraform with AWS
Initialize Terraform to download necessary provider plugins:

terraform init
Copy
Step 5: Validate, Plan, and Apply the Configuration
Validate your Terraform configuration:

terraform validate
Copy
Plan your deployment, reviewing the resources that will be created:

terraform plan
Copy
Apply the configuration to create resources:

terraform apply
Copy
Important Considerations
Role Trust Policies: Ensure that the trust policies are correctly set to allow the role assumption where specified.

Sam Application Files: Ensure template.yaml exists in the specified path and contains your AWS SAM configuration.

Security: Always use environment variables or IAM roles for managing credentials securely. Avoid hardcoding them in your scripts.

Permissions: Ensure that the delegated role has permissions to create and manage the necessary AWS resources, including IAM roles and CloudFormation stacks.

This setup should create the necessary IAM roles and deploy your SAM application. Adjust paths, region, and any specific setup required by your application (like parameters in template.yaml) as necessary.
