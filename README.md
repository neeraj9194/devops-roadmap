# Devops Roadmap (Infrastructure)

A terraform project to create AWS infrastructure to a web application with its container registry 

## Overview

The following diagram shows the key components of the configuration for this module:

![The following diagram shows the key components of the infrastructure (in progress..)](https://raw.githubusercontent.com/neeraj9194/devops-roadmap/main/docs/devops-roadmap.png)

# Requirements

- Setup `aws cli` or have `~/.aws/credentials` file so that terraform can call API using your AWS account.
- Install terraform
- Install ansible

# Quick Start

## Infrastructure provisioning

- The first step is to generate the SSH keys, that will be used to login to service boxes. 
    
    > This will generate 2 files Public key and private key, use public key path in tfvars in next step. 
    ```
    # create the keys.
    ssh-keygen -m PEM -f "~/.ssh/awskey"

    # Add ssh keys to keychain
    ssh-add <PrivateKeypath>
    ```

- Now, Create a tfvar file to overwrite default variable values, edit `ap-south.tfvars.example` and add your valuesin it.

    > Add DB user and password. Also add public key path that you added above.

- Now you can run terraform command to deploy all the changes. Yo
    ```
    terraform plan -var-file=ap-south.tfvars
    OR
    terraform apply -var-file=ap-south.tfvars
    ```

> After setup you can connect to bastion using this command.

    ssh -i ~/.ssh/awskey -A ubuntu@<Bastion-public-ip>
    
## Software provisioning

- Firstly, Install aws dynamic inventory plugin for ansible, it will be used to fetch hosts from AWS.

    ```
    ansible-galaxy collection install amazon.aws
    ```

- Now if you have run terraform apply command it will create 3 things in ansible directory.
    
    1. File `ansible/s3_keys.yaml`. It has secret for S3 users both Read-only and R/W. Copy themin vault.yaml.
    2. File `ansible/terraform_vars.yaml`. It contains all the variables/outputs from terraform.
    3. Directory `ansible/cert` which contains SSL certificates for LB.

- Now you have to create a vault which will have values as given in `ansible/vault.yaml.example`. Copy it and edit your secrets. 

    ```
    # name vault.yaml is hardcoded right now so use that name only.
    ansible-vault encrypt vault.yaml
    ```

- Run playbook, 
    ```
    cd ansible

    ansible-playbook configure_service.yaml -i aws_ec2.yaml -v --ask-vault-pass
    ```


> In-progress...


## TODO (infrastructure)

- [x] Application Load Balancer

- [x] Two bastion machines (one per AZ).

- [x] Attach 8 GB extra EBS volume.

- [x] RDS

- [x] S3 buckets with users.


## TODO (software provisioning) 

- [x] Docker registry service, integrated with ansible.

- [ ] Django application.  

- [-] Ansible deployments

- [ ] CI/CD using Jenkins.
