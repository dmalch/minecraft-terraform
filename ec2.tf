resource "aws_instance" "minecraft-ec2" {
  ami                         = data.aws_ami.ubuntu.image_id
  iam_instance_profile        = aws_iam_instance_profile.minecraft.id
  instance_type               = "t2.medium"
  subnet_id                   = sort(module.vpc.public_subnets)[0]
  vpc_security_group_ids      = [module.security-group.security_group_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_ssh[0].key_name

  user_data = templatefile("${path.module}/run_minecraft.sh", {
    minecraft_version = "latest"
    minecraft_bucket  = local.bucket
  })
}
