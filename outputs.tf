output "external_ip" {
    value = "${aws_instance.terraform_ansible_host[*].public_ip}"
}

output "instance_id" {
    value = "${aws_instance.terraform_ansible_host[*].tags_all.Name}"
}
output "ansible_host" {
    value = formatlist(
        "%v ansible_ssh_host=%v",
            split(",","${join(",",aws_instance.terraform_ansible_host[*].tags_all.Name)}"),
            split(",","${join(",",aws_instance.terraform_ansible_host[*].public_ip)}")
        )
}