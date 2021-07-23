#!/usr/bin/env bash

apt-get update
apt-get install -y openjdk-11-jdk
cat /vagrant/master-key.pub >> /home/vagrant/.ssh/authorized_keys

# Install docker make it sudo free.
# sudo groupadd docker
# sudo usermod -aG docker $USER