export AWS_DEFAULT_REGION=ap-southeast-2

AWS_IMAGE=public.ecr.aws/dnxsolutions/aws-v2:2.2.9-dnx1
TERRAFORM_IMAGE=public.ecr.aws/dnxsolutions/terraform:1.0.0-dnx1

RUN_AWS        =docker run -i --rm --env-file=.env --env-file=.env.assume -v $(PWD):/work -v $(HOME)/.aws:/root/.aws --entrypoint "" $(AWS_IMAGE)
RUN_TERRAFORM  =docker run -i --rm --env-file=.env --env-file=.env.assume -v $(PWD):/work -v $(HOME)/.aws:/root/.aws --entrypoint "" $(TERRAFORM_IMAGE)

ifdef CI
	RUN_TERRAFORM  =docker run -i --rm --env-file=.env -v $(PWD):/work --entrypoint "" $(TERRAFORM_IMAGE)
endif

export ASSUME_REQUIRED?=assume-role
export AWS_ROLE?=InfraDeployAccess

############################
# Env and Authentication
############################

env-%: # Check for specific environment variables
	@ if [ "${${*}}" = "" ]; then echo "Environment variable $* not set"; exit 1;fi

.env:
	cp .env.template .env
	echo >> .env
	touch .env.assume
.PHONY: .env	

assume-role: .env
	echo > .env.assume
	$(RUN_AWS) assume-role.sh > .env.assume
.PHONY: assume-role

clean-dotenv:
	-rm .env
.PHONY: clean-dotenv

######################
# Terraform Commands
######################

_init:
	terraform init
	terraform workspace new $(WORKSPACE) 2>/dev/null; true # ignore if workspace already exists
	terraform workspace "select" $(WORKSPACE)

_lint:
	terraform fmt --recursive -check=true

_validate:
	terraform validate

_plan:
	terraform plan -out=.terraform-plan-$(WORKSPACE)

_apply:
	terraform apply .terraform-plan-$(WORKSPACE)

_output:
	terraform output -json > output.json

######################
# Entry Points
######################

init: .env env-WORKSPACE
	$(RUN_TERRAFORM) make _init
.PHONY: init

lint: .env
	$(RUN_TERRAFORM) make _lint
.PHONY: lint

validate: .env
	$(RUN_TERRAFORM) make _validate
.PHONY: validate

apply: .env $(ASSUME_REQUIRED) env-WORKSPACE
	$(RUN_TERRAFORM) make _apply
.PHONY: apply

plan: .env env-WORKSPACE
	$(RUN_TERRAFORM) make _plan
.PHONY: plan

output:
	@$(RUN_TERRAFORM) make _output
.PHONY: output

######################
# Utilities
######################

shell: .env
	docker run -it --rm  --env-file=.env --env-file=.env.assume -v $(PWD):/work -v $(HOME)/.aws:/root/.aws --entrypoint "/bin/bash" $(TERRAFORM_IMAGE)
.PHONY: shell

check_clean:
	@echo "Are you sure you want to delete the files? It's including (terraform files, gsuite xml and git repository) [yes/no] " && read ans && [ $${ans:-N} == yes ]
.PHONY: check_clean

clean: check_clean .env
	echo "+++ :system: Cleaning default files"
	rm -rf .terraform terraform.tfstate* terraform.tfstate.d .git ||:
.PHONY: clean