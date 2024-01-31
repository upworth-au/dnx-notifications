# Baseline Terraform Stack

This stack manages the creation of Databases, ElasticbeanStalk, KMS, Secrets, Buckets, WAF and necessary resoucers that involves application.

## Workspaces
Workspaces are segregated by `.yaml` files and are store under the `.workspaces` folder.

### Name convetion
The name pattern used by the workspaces is defined by the name of the environment and the region. `<env_name>-<region>.yaml`
Example: dev-ap-southeast-2.yaml

## Configuration Variables

All configuration is loaded from the folder `.workspaces` by the file `_settings.tf`.

Variables can change per workspace, to access a variable in your .tf file, set at the workspace configuration file under all workspaces and use: `local.workspace.my_variable`

Variables that are common to all workspaces can be set at `_settings.tf`.


## Resources

- IAM Roles (Vanta Integration)

## Workspaces

- audit-ap-southeast-2
- dev-ap-southeast-2
- log-ap-southeast-2
- prod-ap-southeast-2
- shared-ap-southeast-2

## Deploying

### 1. Export Workspace

1. audit            `export AWS_ACCOUNT_ID=287119080748 WORKSPACE=audit-ap-southeast-2`
2. dev:             `export AWS_ACCOUNT_ID=315424472687 WORKSPACE=dev-ap-southeast-2`
3. log:             `export AWS_ACCOUNT_ID=407644281732 WORKSPACE=log-ap-southeast-2`
4. prod:            `export AWS_ACCOUNT_ID=450799859508 WORKSPACE=prod-ap-southeast-2`
5. shared-servies:  `export AWS_ACCOUNT_ID=157927539262 WORKSPACE=shared-ap-southeast-2`

### 2. AWS Credentials
You must set the AWS credentials following the [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).

### 3. terraform init
```
make init
```

### 4. terraform plan
```
make plan
```

### 5. terraform apply
```
make apply
```

### Other operations supported
Enter a shell with AWS credentials and terraform:
```
make shell

# common commands to run inside the shell:

# check your AWS creds by running:
aws sts get-caller-identity

# list terraform state with:
terraform state list

# import a terraform resource:
terraform import aws_guardduty_detector.member[0] 00b00fd5aecc0ab60a708659477e0627
```