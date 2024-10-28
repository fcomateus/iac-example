provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "my-key" {
    key_name = "my-key"
    ## public_key = file("C:/Users/endry/.ssh/id_rsa.pub")
    public_key = file("/home/mateus/.ssh/id_rsa.pub")
}

resource "aws_security_group" "my-sg" {
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  
}

resource "aws_instance" "my-instance" {
    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    key_name = "my-key"
    # count = 1
    tags = {
      Name = "unifor"
      type = "universidade"
    }
    security_groups = [ "${aws_security_group.my-sg.name}" ]
    provisioner "remote-exec" {
      connection {
        type = "ssh"
        user = "ubuntu"
        ##private_key = file("C:/Users/endry/.ssh/id_rsa")
        private_key = file("/home/mateus/.ssh/id_rsa")
        host = self.public_ip
      }
      inline = [ 
        "sudo apt update",
        "sudo apt install -y nginx"
      ]
    }
}

output "instance_ip" {
  value = aws_instance.my-instance.public_ip
}