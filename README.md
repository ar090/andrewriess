# Hubsy

This is my personal website running serverlessly via AWS.

# Deployment

Bucket is set to sync and detech changes using terraform. 

To Update, Run:
```bash
make init       - Initializes the Terraform repository.
make plan       - Performs the Terraform plan.
make apply      - Performs the Terraform apply.
make sync       - Syncs web files with S3
make invalidate - Clears CloudFront cache
make full       - Syncs and clears cache 
```
Make plan & Make apply 

## Release History

### August 1 2017

