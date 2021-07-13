# Devops Roadmap (Infrastructure)

A terraform project to create AWS infrastructure to a web application with its container registery 

## Overview

The following diagram shows the key components of the configuration for this module:

![The following diagram shows the key components of the infrastructure (in progress..)](https://raw.githubusercontent.com/neeraj9194/devops-roadmap/main/docs/devops-roadmap.png)


## Quick Start (infrastructure)

The first step is to generate the SSH keys. In the terraform directory create another directory called keys and create your keys with the following command:

```
# create the keys
# enter the file path to create. And use same file path in variable `key_path` in terraform command.
ssh-keygen -m PEM

# Add key to keygen
ssh-add <PrivateKeypath>
```

Now you can run terraform command to deploy all the changes. Yo
```
# will ask you for DB password to set for RDS.

terraform plan -var key_path="~/.ssh/awskey.pub"
OR
terraform apply -var key_path="~/.ssh/awskey.pub"
```

After setup you can connect to bastion using this command.
```
ssh -i ~/.ssh/awskey -A ubuntu@<Bastion-public-ip>
```

## Ansible

Install ansible plugin

```
ansible-galaxy collection install amazon.aws
```

Run playbook
```
cd ansible

ansible-playbook deploy-registery.yaml -v --ask-vault-pass
```


> In-progress...


## TODO (infrastructure)

- [x] Application Load Balancer

- [x] Two bastion machines (one per AZ).

- [x] Attach 8 GB extra EBS volume.

- [x] RDS

- [x] S3 buckets with users.


## TODO (software provisioning) 

- [ ] Docker registery service.

- [ ] Software provisioning and 

- [ ] Ansible deployments

- [ ] CI/CD using Jenkins.
