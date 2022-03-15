provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "terraform_ansible_host" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"
  associate_public_ip_address  = true
  key_name= "myawsfreetierkey"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  tags = {
    Name = "terraform_instance-${count.index + 1}"
  }
  count = 1

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt install firewalld",
      "sudo adduser --disabled-password --gecos '' myuser",
      "sudo mkdir -p /home/myuser/.ssh",
      "sudo touch /home/myuser/.ssh/authorized_keys",
      "sudo echo '${var.ami_key_pair_name}' > authorized_keys",
      "sudo mv authorized_keys /home/myuser/.ssh",
      "sudo chown -R myuser:myuser /home/myuser/.ssh",
      "sudo chmod 700 /home/myuser/.ssh",
      "sudo chmod 600 /home/myuser/.ssh/authorized_keys",
      "sudo usermod -aG sudo myuser",
      "sudo sh -c 'echo \"myuser ALL=(ALL) NOPASSWD: ALL\" > etc/sudoers.d/myuser'"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file("${var.ssh_public_key}")
    }
  }
}
