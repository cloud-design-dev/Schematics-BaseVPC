module vpc {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Module.git"
  name           = "${var.name}-vpc"
  resource_group = data.ibm_resource_group.rg.id
  tags           = concat(var.tags, ["region:${var.region}"])
}

module public_gateway {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Public-Gateway-Module.git"
  name           = "${var.name}-pub-gw"
  zone           = data.ibm_is_zones.mzr.zones[0]
  vpc            = module.vpc.id
  resource_group = data.ibm_resource_group.rg.id
  tags           = concat(var.tags, ["vpc:${var.name}-vpc", "zone:${data.ibm_is_zones.mzr.zones[0]}"])
}

module subnet {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Subnet-Module.git"
  name           = "${var.name}-subnet"
  resource_group = data.ibm_resource_group.rg.id
  address_count  = "128"
  vpc            = module.vpc.id
  zone           = data.ibm_is_zones.mzr.zones[0]
  public_gateway = module.public_gateway.id
}

module "vpc-bastion" {
  source            = "we-work-in-the-cloud/vpc-bastion/ibm"
  version           = "0.0.7"
  name              = "${var.name}-bastion"
  resource_group_id = data.ibm_resource_group.rg.id
  vpc_id            = module.vpc.id
  subnet_id         = module.subnet.id
  ssh_key_ids       = [data.ibm_is_ssh_key.regional_ssh_key.id]
  allow_ssh_from    = var.local_ip
  create_public_ip  = true
  init_script       = file("${path.module}/install.yml")
}