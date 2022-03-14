variable "ssh_public_key" {
    description = "file path for ssh pub key"
    type = string
    default = "~/.ssh/id_rsa.pub"
}
variable "ami_key_pair_name"{}