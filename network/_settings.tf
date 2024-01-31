locals {
  stack_name = "network"
  workspace  = yamldecode(file("./workspaces/${terraform.workspace}.yaml"))
  aws_role   = "InfraDeployAccess"
}