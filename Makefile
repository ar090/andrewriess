# Configuration variables.
TERRAFORM_VERSION := 0.9.9
AWS_REGION := us-east-1
AWS_PROFILE := andrewriess

# Launch Terraform in a isolated docker container.
TERRAFORM := docker run --rm -it -e AWS_PROFILE=${AWS_PROFILE} -e AWS_REGION=${AWS_REGION} -v ~/.aws:/root/.aws -v ${PWD}:/data -w /data hashicorp/terraform:${TERRAFORM_VERSION}

# Syncing the website to S3 bucket.
sync:
	AWS_PROFILE=${AWS_PROFILE} aws s3 sync ./ s3://andrew-riess-site/ --exclude ".dir"

# Initialize the Terraform backend.
init:
	rm -rf .terraform && \
	${TERRAFORM} init \
		-backend=true \
		-backend-config="bucket=andrew-riess-terraform" \
		-backend-config="key=terraform.tfstate" \
		-backend-config="region=${AWS_REGION}" \
		-backend-config="profile=${AWS_PROFILE}" \
		-force-copy

# Planning will sync the landing page to s3, 
# initialize Terraform backend and then do a Terraform plan.
plan: sync init
	${TERRAFORM} plan -var="aws_region=${AWS_REGION}" -out=.terraform/terraform.tfplan	

# Run a Terraform apply against the plan that was ran. It will also do a little
# cleanup and remove any zip files it created.
apply:
	${TERRAFORM} apply .terraform/terraform.tfplan