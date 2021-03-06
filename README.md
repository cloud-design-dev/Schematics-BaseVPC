[![tf-validate](https://github.com/cloud-design-dev/Schematics-BaseVPC/actions/workflows/main.yml/badge.svg)](https://github.com/cloud-design-dev/Schematics-BaseVPC/actions/workflows/main.yml)

# Schematics Base VPC

An IBM Cloud [Schematics](https://cloud.ibm.com/docs/schematics?topic=schematics-about-schematics) template for a simple VPC environment. The VPC will deploy:
 - An IBM Cloud [VPC](https://cloud.ibm.com/docs/vpc?topic=vpc-about-vpc) in one of the available [multizone regions](https://cloud.ibm.com/docs/overview?topic=overview-locations#mzr-table).
 - A [public gateway](https://cloud.ibm.com/docs/vpc?topic=vpc-about-networking-for-vpc#public-gateway-for-external-connectivity) in each of the regions 3 zones. 
 - A [subnet](https://cloud.ibm.com/docs/vpc?topic=vpc-vpc-addressing-plan-design) in each of the regions 3 zones attached to that zones Public Gateway. 
 - A [bastion](https://github.com/we-work-in-the-cloud/terraform-ibm-vpc-bastion) server in the first zone in the region that only allows SSH access from specific IPs/subnets.
 - An ansible inventory file to interact with the deployed resources [not-complete](#)

## Deploy all resources via Terraform
1. Clone repository:
    ```sh
    git clone https://github.com/cloud-design-dev/Schematics-BaseVPC.git
    cd Schematics-BaseVPC
    ```
1. Copy `terraform.tfvars.template` to `terraform.tfvars`:
   ```sh
   cp terraform.tfvars.template terraform.tfvars
   ```
1. Edit `terraform.tfvars` to match your environment.
1. Run `tfswitch` to point to the right Terraform version for this solution:
   ```
   tfswitch
   ```
1. Deploy all resources:
   ```sh
   terraform init
   terraform plan -out default.tfplan 
   terraform apply default.tfplan
   ```
## Deploy all resources via Schematics

[![Deploy using Schematics](https://cloud.ibm.com/devops/setup/deploy/button_x2.png)](https://cloud.ibm.com/schematics/workspaces/create?repository=https://github.com/cloud-design-dev/Schematics-BaseVPC&terraform_version=terraform_v0.14)

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ibmcloud\_api\_key | IBM Cloud API key to create resources. | `string` | n/a | yes |
| name | Label that will be assigned to the VPC and associated resources. | `string` | n/a | yes |
| region | The VPC region where the resources will be provisioned | `string` | `"us-east"` | yes |
| resource\_group | Name of the resource group to associate with the deployed resources. | `string` | n/a | yes |
| allow\_ssh\_from | An IP address, CIDR block, or a single security group identifier to allow incoming SSH connection to the bastion. | `string` | `"0.0.0.0/0"`| no |
| image\_name | Name of the image to use for the virtual server instance | `string` | `"ibm-ubuntu-20-04-minimal-amd64-2"` | no |
| user\_data\_script | Script to run during the instance initialization. Defaults to an Ubuntu specific [script](https://github.com/we-work-in-the-cloud/terraform-ibm-vpc-bastion/blob/master/init-script-ubuntu.sh) when set to empty. | `string` | `""` | no |
| profile\_name | Instance profile to use for the virtual server instance | `string` | `"cx2-2x4"` | no |
| ssh\_key | Name of an existing IBM Cloud SSH Key in the choosen Region. | `string` | n/a | no |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc\_id | ID of the created VPC |
| ssh\_command | SSH command to run against any instances deployed behind the bastion |
| public\_gateway\_ids | Public Gateway IDs |
| subnet\_ids | Subnet IDs |
| subnet\_cidrs | CIDR block of created subnets |
| bastion\_address | Public IP of the bastion instance |

## Diagram
![Diagram of deployment](vpc-diagram.png)

Diagram generated using [vpc-diagram-exporter](https://github.com/l2fprod/vpc-diagram-exporter).
