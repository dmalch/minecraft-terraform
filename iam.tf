resource "aws_iam_role" "allow_s3" {
  name               = "minecraft-allow-ec2-to-s3"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "minecraft" {
  name = "minecraft-instance-profile"
  role = aws_iam_role.allow_s3.name
}

resource "aws_iam_role_policy" "minecraft_allow_ec2_to_s3" {
  name   = "minecraft-allow-ec2-to-s3"
  role   = aws_iam_role.allow_s3.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${local.bucket}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::${local.bucket}/*"]
    }
  ]
}
EOF
}
