resource "aws_vpc" "minecraft-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "minecraft_gateway" {
  vpc_id = aws_vpc.minecraft-vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.minecraft-vpc.id
  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.minecraft_gateway.id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    }
  ]
}

resource "aws_route" "public_internet_gateway" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.minecraft_gateway.id

  timeouts {
    create = "5m"
  }
}

resource "aws_subnet" "minecraft_public" {
  vpc_id                  = aws_vpc.minecraft-vpc.id
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.minecraft_public.id
}
