# Devops Roadmap (Infrastructure)

A terraform project to create AWS infrastructure to a web application with its container registry 

## Overview

The following diagram shows the key components of the configuration for this module:

![The following diagram shows the key components of the infrastructure (in progress..)](https://raw.githubusercontent.com/neeraj9194/devops-roadmap/main/docs/devops-roadmap.png)

# Requirements

- Setup `aws cli` or have `~/.aws/credentials` file so that terraform can call API using your AWS account.
- Install terraform
- Install ansible
- VirtualBox
- Vagrant


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
    # above collection requires boto3 and botocore
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
    make deploy
    ```
    The above command will deploy docker `registry`, a django app and initialize DB with default user.

### Other Make commands you can use
```
make init_server      # to initlize server with python packages and docker
make deploy_registry  # only deploy registry
make deploy_app       # only deploy django app
make init_db          # initialize DB with default user. 
```

> Now you can login into application on LB dns address, goto 
`<lb-dns-address>/api-auth/login/`


## CI/CD with Jenkins

From makefile you can startup the vagrant machines

```
make jenkins
```
This will start 2 machines 1 master jenkins server 1 slave. You can access your jenkins on `localhost:8080`

> Because jenkins uses ansible to deploy your app the files mentioned above are also important here.
  For, `ansible/terraform_vars.yaml` and `ansible/vault.yaml`, You need to copy these files
  to your local `/vagrant` directory which will be auto mounted to machines.

  For, `ansible/cert/*` you have to copy it to `/etc/docker/certs.d/<load balancer dns>/` 


Now, you need to setup node to connect a slave(hostname: jenkins-slave) to master. See online instructions https://wiki.jenkins.io/pages/viewpage.action?pageId=72778132

After that you can setup a pipeline project, `vagrant/jenkins/Jenkinsfile` can be used for the script.

You also have to add few credentials, for pipeline to work.

1. Credential named `AnsibleVault`(type: Secret text) contaning vault password.
2. `aws-id` AWS key and secret(type: AWS credentials) to list the host machines to deploy (used by ansible).
3. `aws-ssh-key`(type: "SSH username with Key") which stores the private key we created/used in terraform to initilize service machines.

Plugins:

These plugins are required in order to run the above pipeline.
`Ansible plugin`, `Docker Pipeline`, `SSH Agent Plugin` 



## TODO (infrastructure)

- [x] Application Load Balancer

- [x] Two bastion machines (one per AZ).

- [x] Attach 8 GB extra EBS volume.

- [x] RDS

- [x] S3 buckets with users.


## TODO (software provisioning) 

- [x] Docker registry service, integrated with ansible.

- [x] Django application.  

- [x] Containerize the application using docker.

- [x] make file to run tests, create docker images and push to docker registry.

- [x] Ansible's dynamic inventory to provision the application.

- [x] CI using Jenkins.

- [x] CD Pipeline