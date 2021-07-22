#!/usr/bin/env bash

apt-get update

# Jenkins & Java
echo "Installing Jenkins and Java"
apt-get install -y openjdk-11-jdk

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install -y jenkins

# Network setup
mkdir -p /var/lib/jenkins/.ssh
sudo ssh-keygen -b 2048 -t rsa -f /var/lib/jenkins/.ssh/id_rsa -q -N ""
cat /var/lib/jenkins/.ssh/id_rsa.pub > /vagrant/master-key.pub
echo "Jenkins user ssh keys generated"

sudo cat >> /etc/hosts <<EOF
#jenkins servers - forced since no DNS
10.0.0.10       jenkins-master
10.0.0.11       jenkins-slave
EOF
echo "Added jenkins master/slave to hosts file"