module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = "minecraft-public"

  key_name             = aws_key_pair.ec2_ssh[0].key_name
  ami                  = data.aws_ami.ubuntu.image_id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.minecraft.id

  subnet_id                   = sort(data.aws_subnet_ids.default.ids)[0]
  vpc_security_group_ids      = [module.security-group.security_group_id]
  associate_public_ip_address = true
}
