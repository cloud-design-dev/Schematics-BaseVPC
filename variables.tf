variable "region" {
  type        = string
  description = "The region where the VPC resources will be deployed."
  default     = ""
}

variable "ssh_key" {
  type        = string
  description = "The SSH Key that will be added to the compute instances in the region."
  default     = ""
}

variable "resource_group" {
  type        = string
  description = "Resource group where resources will be deployed."
  default     = ""
}

variable "name" {
  type = string
  description = "Name for the VPC. This will be prepended to any associated resource names."
  default = ""
}

variable "local_ip" {
  type = string
  description = "Bastion host will allow SSH from this IP address."
  default = ""
}