module vpc {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Module.git"
  name           = "${var.name}-vpc"
  resource_group = data.ibm_resource_group.rg.id
  tags           = concat(var.tags, ["region:${var.region}"])
}

module public_gateway {
  count          = length(data.ibm_is_zones.mzr.zones)
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Public-Gateway-Module.git"
  name           = "${var.name}-${element(data.ibm_is_zones.mzr.zones, count.index)}-pub-gw"
  zone           = data.ibm_is_zones.mzr.zones[count.index]
  vpc            = module.vpc.id
  resource_group = data.ibm_resource_group.rg.id
  tags           = concat(var.tags, ["vpc:${var.name}-vpc", "zone:${data.ibm_is_zones.mzr.zones[count.index]}"])
}

module subnet {
  count          = length(data.ibm_is_zones.mzr.zones)
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Subnet-Module.git"
  name           = "${var.name}-${element(data.ibm_is_zones.mzr.zones, count.index)}-subnet"
  resource_group = data.ibm_resource_group.rg.id
  address_count  = "128"
  vpc            = module.vpc.id
  zone           = data.ibm_is_zones.mzr.zones[count.index]
  public_gateway = module.public_gateway[count.index].id
}

module "vpc-bastion" {
  source            = "we-work-in-the-cloud/vpc-bastion/ibm"
  version           = "0.0.7"
  name              = "${var.name}-bastion"
  resource_group_id = data.ibm_resource_group.rg.id
  vpc_id            = module.vpc.id
  subnet_id         = module.subnet[0].id
  ssh_key_ids       = [data.ibm_is_ssh_key.regional_ssh_key.id]
  allow_ssh_from    = var.local_ip
  create_public_ip  = true
  init_script       = file("${path.module}/install.yml")
}