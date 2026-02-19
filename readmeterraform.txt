
Notes:
Replace "us-east-1" with your AWS region.
Avoid hardcoding credentials in production; prefer environment variables or shared credential files.
Ensure the IAM policies are correctly attached to the roles or users.
If you need to create policies or attach existing ones, add relevant Terraform resources.
Summary:

Use the provider "aws" block to specify credentials.
To assume a role, use assume_role inside the provider configuration.
Use resource blocks to create IAM users and roles with specified naming conventions and attach permission boundaries.


Using Environment Variables: Instead of hardcoding keys, set environment variables:
export AWS_ACCESS_KEY_ID="aaaaawdsafdsg"
export AWS_SECRET_ACCESS_KEY="dskjflkhorenv"
Copy




1.And update provider block:

2.provider "aws" {
  region = "us-east-1"
}

Terraform will automatically look for AWS credentials in environment variables if they are set.

Terraform's AWS provider uses the default credential chain built into the AWS SDK, which includes:

Environment variables:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
(and optionally AWS_SESSION_TOKEN)
Shared credentials file (~/.aws/credentials):

Profile named default (or other named profiles if specified).
EC2 Instance Profile / ECS Task Role.

So, in your setup, if you set:
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
Copy
then the provider will use these environment variables automatically without needing to explicitly specify credentials inside your Terraform configuration.


