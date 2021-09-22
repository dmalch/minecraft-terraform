resource "aws_key_pair" "ec2_ssh" {
  count      = 1
  key_name   = "minecraft-ec2-ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDJvLu4a6dl8Y2HSP2lT4TQbeODx+UmEacDCyNFAH5Y dmalch@gmail.com"
}
