
# Provider with static credentials (not recommended for production)
provider "aws" {
  region     = "us-east-1"
  access_key = "aaaaawdsafdsg"
  secret_key = "dskjflkhorenv"

  # To assume a role instead of static credentials, comment above and use assume_role below
  assume_role {
    role_arn = "arn:aws:iam::622385389008:role/role-destination-recommender-agent"
  }
}

# Create a role with the specified naming convention and permission boundary
resource "aws_iam_role" "agent_role" {
  name               = "agent-destination-recommender"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::622385898:user/svc-destination-recommender-agent"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  permissions_boundary = "arn:aws:iam::622385389008:policy/custom-DeveloperRoleBoundary"
}

# Optionally create a user with permissions boundary
resource "aws_iam_user" "agent_user" {
  name               = "agent-svc-destination-recommender"
  permissions_boundary = "arn:aws:iam::622385389008:policy/custom-DeveloperRoleBoundary"
}
