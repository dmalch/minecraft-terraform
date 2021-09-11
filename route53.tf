resource "aws_route53_zone" "mcisar" {
  name = "mcisar.com"
}

resource "aws_route53_record" "minecraft" {
  zone_id = aws_route53_zone.mcisar.zone_id
  name    = "mcisar.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.minecraft-ec2.public_ip]
}

resource "aws_route53_record" "minecraft-srv" {
  zone_id = aws_route53_zone.mcisar.zone_id
  name    = "mcisar.com"
  type    = "SRV"
  ttl     = "300"
  records = ["0 5 25565 mcisar.com"]
}
