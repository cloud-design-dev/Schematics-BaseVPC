# output "ssh_command" {
#   value       = "ssh -o StrictHostKeyChecking=no -o ProxyCommand='ssh -o StrictHostKeyChecking=no -W %h:%p root@${var.create_public_ip ? module.vpc-bastion.bastion_public_ip : module.vpc-bastion.bastion_private_ip}' root@${ibm_is_instance.instance.primary_network_interface[0].primary_ipv4_address}"
#   description = "Command to use to jump from the bastion to the instance assuming you are using your own default SSH key on bastion and instances"
# }

output "vpc_id" {
  value = module.vpc.id
}