output "ssh_command" {
  value       = "ssh -o StrictHostKeyChecking=no -o ProxyCommand='ssh -o StrictHostKeyChecking=no -W %h:%p root@${var.create_public_ip ? module.vpc-bastion.bastion_public_ip : module.vpc-bastion.bastion_private_ip}' root@VPC_PRIVATE_IP"
  description = "Command to use to jump from the bastion to the instance assuming you are using your own default SSH key on bastion and instances"
}

output "vpc_id" {
  value = module.vpc.id
}

output "public_gateways" {
  value = module.public_gateway[*].gateway
}

output "subnet_cidrs" {
  value = module.subnet[*].ipv4_cidr_block
}