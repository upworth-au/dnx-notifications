locals {
  stack_name = "network"
  workspace  = yamldecode(file("./workspaces/${terraform.workspace}.yaml"))
  aws_role   = "InfraDeployAccess"
}

provider "aws" {
  region = local.workspace.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${local.workspace.aws_account_id}:role/${local.aws_role}"
  }
}