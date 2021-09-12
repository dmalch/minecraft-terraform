resource "aws_security_group" "minecraft_ec2_ssh_and_minecraft" {
  name        = "minecraft-ec2-ssh-and-minecraft-20210829120349142100000001"
  description = "Allow SSH and TCP ${local.mc_port}"
  vpc_id      = aws_vpc.minecraft-vpc.id

  ingress = [
    {
      from_port = local.mc_port
      to_port   = local.mc_port
      protocol  = "tcp"
      # cidr_blocks      = [aws_vpc.minecraft-vpc.cidr_block]
      cidr_blocks = ["0.0.0.0/0"]
      # ipv6_cidr_blocks = [aws_vpc.minecraft-vpc.ipv6_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "Minecraft server"
    },
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      # cidr_blocks      = [aws_vpc.minecraft-vpc.cidr_block]
      cidr_blocks = ["0.0.0.0/0"]
      # ipv6_cidr_blocks = [aws_vpc.minecraft-vpc.ipv6_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "SSH"
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "All protocols"
    }
  ]
}
