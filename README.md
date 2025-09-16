# Strapi CMS Deployment with Terraform on AWS.
# Files in this Repo
•	provider.tf → AWS provider config
•	main.tf → EC2 instance + security group + Docker setup
•	variables.tf → Input variables
•	outputs.tf → Public IP output
•	README.md → Documentation

This project uses *Terraform* to deploy the official *Strapi Headless CMS* on an AWS EC2 instance.  
The EC2 instance runs Docker and pulls the Strapi image.

---

## Steps to Deploy

### 1. Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- AWS account with access keys configured (aws configure)
- IAM user with *AmazonEC2FullAccess*

---

### 2. Clone the Repository
```bash
git clone https://github.com/<your-username>/strapi-terraform.git
cd strapi-terraform
