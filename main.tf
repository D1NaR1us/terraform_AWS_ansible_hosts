provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "terraform_ansible_host" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"
  associate_public_ip_address  = true
  key_name= "myawsfreetierkey"
  security_groups = [aws_security_group.allow_tls.id]
  subnet_id       = aws_subnet.test_main_subnet.id
  tags = {
    Name = "terraform_instance-${count.index + 1}"
  }
  count = 1

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("var.ssh_public_key")
  }

}
