resource "aws_route53_zone" "mcisar" {
  name = "mcisar.com"
}

resource "aws_route53_record" "mcisar_ns" {
  zone_id = aws_route53_zone.mcisar.zone_id
  name    = "mcisar.com"
  type    = "NS"
  ttl     = "172800"
  records = ["ns-815.awsdns-37.net.", "ns-1055.awsdns-03.org.", "ns-155.awsdns-19.com.", "ns-1980.awsdns-55.co.uk."]
}

resource "aws_route53_record" "mcisar_soa" {
  zone_id = aws_route53_zone.mcisar.zone_id
  name    = "mcisar.com"
  type    = "SOA"
  ttl     = "900"
  records = ["ns-815.awsdns-37.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
}

resource "aws_route53_record" "minecraft" {
  zone_id = aws_route53_zone.mcisar.zone_id
  name    = "mcisar.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.docker-ec2.public_ip]
}

resource "aws_route53_record" "minecraft-srv" {
  zone_id = aws_route53_zone.mcisar.zone_id
  name    = "mcisar.com"
  type    = "SRV"
  ttl     = "300"
  records = ["0 5 25565 mcisar.com"]
}
