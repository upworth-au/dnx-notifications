terraform {
  backend "s3" {
    bucket   = "upworth-terraform-backend"
    key      = "network"
    region   = "ap-southeast-2"
    encrypt  = true
    role_arn = "arn:aws:iam::628659773423:role/TerraformBackendAccess"
  }
}