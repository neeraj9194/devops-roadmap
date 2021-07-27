#!/usr/bin/env bash

apt-get update
apt-get install -y openjdk-11-jdk
cat /vagrant/master-key.pub >> /home/vagrant/.ssh/authorized_keys

# Install docker make it sudo free.
# sudo groupadd docker
# sudo usermod -aG docker $USER

# Install ansible
apt-get -y install python3-pip
apt-get install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install ansible -y
ansible-galaxy collection install amazon.aws
pip3 install boto3
