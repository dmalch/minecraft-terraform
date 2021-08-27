module "security-group" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 4.0"

  name        = "minecraft-ec2-ssh-and-minecraft"
  description = "Allow SSH and TCP ${local.mc_port}"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = local.mc_port
      to_port     = local.mc_port
      protocol    = "tcp"
      description = "Minecraft server"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
