#!/bin/bash
# Krok 1: Pobieranie i Instalacja Puppet Server Master

echo "srl000" > /etc/hostname

apt-get update
apt-get upgrade

wget https://apt.puppet.com/puppet8-release-focal.deb
dpkg -i puppet8-release-focal.deb

apt-get update
apt-get install -y puppetserver
systemctl enable puppetserver

# Konfiguracja Puppet Mastera : /etc/puppetlabs/puppet/puppet.conf
tee /etc/puppetlabs/puppet/puppet.conf > /dev/null <<EOF
[server]
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code
# auto accept PEM from Agent
autosign = true 

[main]
certname = puppetmaster.local
server = puppetmaster.local
environment = production
EOF

echo "Puppet Server has been installed and configured successfully."

export PATH=/opt/puppetlabs/bin:$PATH
# Tworzenie certyfikatu serwera master

# Tworzenie certyfikatu serwera master
systemctl stop puppetserver
rm -rf /etc/puppetlabs/puppet/ssl/*
rm -rf /etc/puppetlabs/puppetserver/ca/*
puppetserver ca setup
systemctl start puppetserver
puppet agent --test 


# Krok 1: Pobieranie i Instalacja Puppet Server Agent
echo "192.168.1.109 srl000" | sudo tee -a /etc/hosts