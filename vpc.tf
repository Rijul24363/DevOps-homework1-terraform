
provider "aws" {
  region     = "ap-south-1"
}

# creating vpc 
resource "aws_vpc" "rizul" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "rizul"
  }
}


# creating elastic ip

resource "aws_eip" "eip" {
  vpc=true
}



# creating a internet gateway

resource "aws_internet_gateway" "rizul-igw" {
  vpc_id = "${aws_vpc.rizul.id}"

  tags = {
    Name = "rizul-internet-gateway"
  }
}

# attach internet gateway to vpc 

resource "aws_internet_gateway_attachment" "rizul4-igw" {
  internet_gateway_id = aws_internet_gateway.rizul-igw.id
  vpc_id              = aws_vpc.rizul.id
}








# creating subnets [public & private]

data "aws_availability_zones" "azs" {
  state = "available"
}



# creating public subnets
resource "aws_subnet" "subnet_rizul_az1" {
  availability_zone = "${data.aws_availability_zones.azs.names[0]}"
  vpc_id     = "${aws_vpc.rizul.id}"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "rizul-public1-subnet"
  }
}

resource "aws_subnet" "subnet_rizul_az2" {
  availability_zone = "${data.aws_availability_zones.azs.names[1]}"
  vpc_id     = "${aws_vpc.rizul.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "rizul-public2-subnet"
  }
}

resource "aws_subnet" "subnet_rizul_az3" {
  availability_zone = "${data.aws_availability_zones.azs.names[2]}"
  vpc_id     = "${aws_vpc.rizul.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "rizul-public3-subnet"
  }
}

#creating private subnets

resource "aws_subnet" "subnet_rizul_az4" {
  availability_zone = "${data.aws_availability_zones.azs.names[0]}"
  vpc_id     = "${aws_vpc.rizul.id}"
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "rizul-private1-subnet"
  }
}

resource "aws_subnet" "subnet_rizul_az5" {
  availability_zone = "${data.aws_availability_zones.azs.names[1]}"
  vpc_id     = "${aws_vpc.rizul.id}"
  cidr_block = "10.0.4.0/24"
  tags = {
    Name = "rizul-private2-subnet"
  }
}

resource "aws_subnet" "subnet_rizul_az6" {
  availability_zone = "${data.aws_availability_zones.azs.names[2]}"
  vpc_id     = "${aws_vpc.rizul.id}"
  cidr_block = "10.0.5.0/24"
  tags = {
    Name = "rizul-private3-subnet"
  }
}


## creating NAT gateways

resource "aws_nat_gateway" "rizul-nat-gw" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.subnet_rizul_az2.id}"
  tags = {
    Name = "rizul-NAT-gw"
  }
}


  # creating route tables

  resource "aws_route_table" "rizul-public-route" {
  vpc_id = "${aws_vpc.rizul.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.rizul-igw.id}"
  }

  tags = {
    Name = "rizul-public-route"
  }
}


# default route table is considered as private route table

resource "aws_default_route_table" "rizul-default-route" {
  default_route_table_id = "${aws_vpc.rizul.default_route_table_id}"
  tags = {
    Name = "rizul-default-route"
  }
}



# subnet association 
# public asociation 
resource "aws_route_table_association" "rizula" {
  subnet_id      = "${aws_subnet.subnet_rizul_az1.id}"
  route_table_id = "${aws_route_table.rizul-public-route.id}"
}

resource "aws_route_table_association" "rizulb" {
  subnet_id      = "${aws_subnet.subnet_rizul_az2.id}"
  route_table_id = "${aws_route_table.rizul-public-route.id}"
}

resource "aws_route_table_association" "rizulc" {
  subnet_id      = "${aws_subnet.subnet_rizul_az3.id}"
  route_table_id = "${aws_route_table.rizul-public-route.id}"
}

# private association 
resource "aws_route_table_association" "rizuld" {
  subnet_id      = "${aws_subnet.subnet_rizul_az4.id}"
  route_table_id = "${aws_vpc.rizul.default_route_table_id}"
}

resource "aws_route_table_association" "rizule" {
  subnet_id      = "${aws_subnet.subnet_rizul_az5.id}"
  route_table_id = "${aws_vpc.rizul.default_route_table_id}"
}

resource "aws_route_table_association" "rizulf" {
  subnet_id      = "${aws_subnet.subnet_rizul_az6.id}"
  route_table_id = "${aws_vpc.rizul.default_route_table_id}"
}









output "rizul_out" {
  value = "${aws_vpc.rizul}"
}

output "azs_out" {
  value = "${data.aws_availability_zones.azs}"
}

