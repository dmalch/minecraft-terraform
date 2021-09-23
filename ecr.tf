resource "aws_ecr_repository" "minecraft-server" {
  name                 = "minecraft-server"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "itzg-minecraft-server" {
  name                 = "itzg-minecraft-server"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
