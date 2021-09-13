output "public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.default.public_ip
}

output "private_ip" {
  description = "Private IP of instance"
  value       = aws_instance.default.private_ip
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = aws_instance.default.private_dns
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = aws_instance.default.id
}

output "ssh_key_pair" {
  description = "Name of the SSH key pair provisioned on the instance"
  value       = var.ssh_key_pair
}

output "security_group_ids" {
  description = "IDs on the AWS Security Groups associated with the instance"
  value = compact(
    concat(
      [var.create_default_security_group == true ? join("", aws_security_group.default.*.id) : ""],
      var.security_groups
    )
  )
}