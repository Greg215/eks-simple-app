# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# outputs Jump host
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
output "public-ip" {
  value = module.jump-host.public_ip
}

output "private_ip" {
  description = "Private IP of instance"
  value       = module.jump-host.private_ip
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = module.jump-host.private_dns
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = module.jump-host.id
}

output "ssh_key_pair" {
  description = "Name of the SSH key pair provisioned on the instance"
  value       = var.key_name
}