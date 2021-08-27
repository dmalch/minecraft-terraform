module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = "minecraft-ec2"

  ami = data.aws_ami.ubuntu.image_id

  associate_public_ip_address = true

  instance_type = "t2.micro"

  vpc_security_group_ids = [module.security-group.security_group_id]

  key_name = aws_key_pair.ec2_ssh[0].key_name

  iam_instance_profile = aws_iam_instance_profile.minecraft.id

  subnet_id = sort(module.vpc.public_subnets)[0]
}
