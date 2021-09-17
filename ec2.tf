resource "aws_instance" "docker-ec2" {
  ami                         = data.aws_ami.ubuntu.image_id
  iam_instance_profile        = aws_iam_instance_profile.docker-instance-profile.id
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.minecraft_public.id
  vpc_security_group_ids      = [aws_security_group.minecraft_ec2_ssh_and_minecraft.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_ssh[0].key_name

  user_data = templatefile("cloud-init-docker.yaml", {
    minecraft_bucket = local.bucket
  })
}
