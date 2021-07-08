# Devops Roadmap (Infrastructure)

A terraform project to create AWS infrastructure to a web application with its container registery 

## Overview

The following diagram shows the key components of the configuration for this module:

![The following diagram shows the key components of the infrastructure (in progress..)](https://raw.githubusercontent.com/neeraj9194/devops-roadmap/main/docs/devops-roadmap.png)


## Quick Start

The first step is to generate the SSH keys. In the terraform directory create another directory called keys and create your keys with the following command:

```
# create the keys
ssh-keygen -f awskeypair
 
# add the keys to the keychain
ssh-add -K awskeypair  
```

> In-progress...


## TODO

- [ ] Application Load Balancer

- [x] Two bastion machines (one per AZ).

- [x] Attach 8 GB extra EBS volume.

- [x] RDS

- [x] S3 buckets with users.

- [ ] Software provisioning and CI/CD etc.
