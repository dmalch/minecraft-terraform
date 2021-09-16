resource "aws_iam_role" "minecraft-allow-ec2-to-s3" {
  name = "minecraft-allow-ec2-to-s3"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "minecraft" {
  name = "minecraft-instance-profile"
  role = aws_iam_role.minecraft-allow-ec2-to-s3.name
}

resource "aws_iam_role_policy" "minecraft_allow_ec2_to_s3" {
  name = "minecraft-allow-ec2-to-s3"
  role = aws_iam_role.minecraft-allow-ec2-to-s3.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["s3:ListBucket"],
        "Resource" : ["arn:aws:s3:::${local.bucket}"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : ["arn:aws:s3:::${local.bucket}/*"]
      }
    ]
  })
}

resource "aws_iam_role" "docker-allow-ec2-to-s3-and-ecr" {
  name = "docker-allow-ec2-to-s3-and-ecr"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "docker-instance-profile" {
  name = "docker-instance-profile"
  role = aws_iam_role.docker-allow-ec2-to-s3-and-ecr.name
}

resource "aws_iam_role_policy" "docker-allow-ec2-to-s3-and-ecr" {
  name = "docker-allow-ec2-to-s3-and-ecr"
  role = aws_iam_role.docker-allow-ec2-to-s3-and-ecr.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["s3:ListBucket"],
        "Resource" : ["arn:aws:s3:::${local.bucket2}"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : ["arn:aws:s3:::${local.bucket2}/*"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_group" "Github" {
  name = "Github"
  path = "/"
}

resource "aws_iam_user" "github" {
  name = "github"
  path = "/"
}

resource "aws_iam_group_policy" "AllowPush" {
  name  = "AllowPush"
  group = aws_iam_group.Github.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage"
        ],
        "Resource" : "arn:aws:ecr:eu-central-1:550157292651:repository/minecraft-server"
      }
    ]
  })
}
resource "aws_iam_group_policy" "LoginToEcr" {
  name  = "LoginToEcr"
  group = aws_iam_group.Github.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "GetAuthorizationToken",
        "Effect" : "Allow",
        "Action" : "ecr:GetAuthorizationToken",
        "Resource" : "*"
      }
    ]
  })
}
