# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE Jump host
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    bucket = "greg-tr-terraform-state"
    key    = "greg-eks/terraform.tfstate"
    region = "eu-central-1"
  }
}


module "jump-host" {
  source = "../modules/jump-host"

  name          = var.name
  ssh_key_pair  = var.key_name
  aws_region    = var.aws_region
  instance_type = var.instance_type

  vpc_id = data.terraform_remote_state.state.outputs.vpc_id
  subnet = element(data.terraform_remote_state.state.outputs.public_subnet_ids, 1)
}