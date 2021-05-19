# Schematics Base VPC

A Schematics template for a simple VPC environment. The VPC will deploy:
 - An IBM Cloud [VPC](https://cloud.ibm.com/docs/vpc?topic=vpc-about-vpc) in one of the available [multizone regions](https://cloud.ibm.com/docs/overview?topic=overview-locations#mzr-table).
 - A [public gateway](https://cloud.ibm.com/docs/vpc?topic=vpc-about-networking-for-vpc#public-gateway-for-external-connectivity) in each of the regions 3 zones. 
 - A [subnet](https://cloud.ibm.com/docs/vpc?topic=vpc-vpc-addressing-plan-design) in each of the regions 3 zones attached to that zones Public Gateway. 
 - A [bastion](https://github.com/we-work-in-the-cloud/terraform-ibm-vpc-bastion) server in the first zone in the region that only allows SSH access from specific IPs/subnets.
 - An ansible inventory file to interact with the deployed resources [not-complete]()




## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Label that will be assigned to the VPC and associated resources. | `string` | n/a | yes |
| region | The VPC region where the resources will be provisioned | `string` | `"us-east"` | yes |
| resource\_group | Name of the resource group to associate with the deployed resources. | `string` | n/a | yes |
| allow\_ssh\_from | An IP address, CIDR block, or a single security group identifier to allow incoming SSH connection to the bastion. | `string` | `"0.0.0.0/0"`| no |
| image\_name | Name of the image to use for the virtual server instance | `string` | `"ibm-ubuntu-20-04-minimal-amd64-2"` | no |
| user\_data\_script | Script to run during the virtual server instance initialization. Defaults to an [Ubuntu specific script](https://github.com/cloud-design-dev/IBM-Cloud-VPC-Instance-Module/blob/main/init.yml) when set to empty | `string` | `""` | no |
| profile\_name | Instance profile to use for the virtual server instance | `string` | `"cx2-2x4"` | no |
| ssh\_key | Name of an existing IBM Cloud SSH Key in the choosen Region. | `string` | n/a | no |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the virtual server instance |
| primary_network_interface_id | ID of the virtual server instances primary network interface  | 
| primary_ip4_address | Primary private IP address of the virtual server instance |