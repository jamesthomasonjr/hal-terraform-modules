output "public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "public_host" {
  value = "${aws_instance.bastion.public_dns}"
}

output "public_dns_host" {
  value = "${aws_route53_record.default.fqdn}"
}

output "security_group" {
  value = "${aws_security_group.bastion_sg.id}"
}
