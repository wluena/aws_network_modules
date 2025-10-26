# Data source for AMI id (needed by the instance resource)
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name    = "name"
    values  = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ------------------------------------------------------------------
# 1. SECURITY GROUP
# ------------------------------------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "${var.prefix}-allow-http-ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = var.vpc_id # Use the VPC ID passed to the module

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags,
    {
      "Name" = "${var.prefix}-sg"
    }
  )
}

# ------------------------------------------------------------------
# 2. KEY PAIR
# ------------------------------------------------------------------
resource "aws_key_pair" "web_key" {
  key_name   = var.prefix
  public_key = file(var.public_key_path) # Use the public key path passed to the module
}


# ------------------------------------------------------------------
# 3. EC2 INSTANCE (using count based on var.instance_count)
# ------------------------------------------------------------------
resource "aws_instance" "my_amazon" {
  count                       = var.instance_count
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type # Use the type passed to the module
  key_name                    = aws_key_pair.web_key.key_name
  # Distribute instances across available subnets
  subnet_id                   = element(var.public_subnets, count.index % length(var.public_subnets)) 
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true # Must be true for public subnet
  user_data = templatefile("${path.module}/install_httpd.sh.tpl", {
    message    = "ACS730 Week 5, Session 1"
    private_ip = aws_instance.web[count.index].private_ip
  })

  tags = merge(var.default_tags,
    {
      "Name" = "${var.prefix}-Amazon-Linux-${count.index + 1}"
    }
  )
}


# ------------------------------------------------------------------
# 4. ELASTIC IP (Assuming only one EIP, attached to the first instance)
# ------------------------------------------------------------------
resource "aws_eip" "static_eip" {
  instance = aws_instance.my_amazon[0].id # Attach to the first instance (index 0)
  
  tags = merge(var.default_tags,
    {
      "Name" = "${var.prefix}-eip"
    }
  )
}
