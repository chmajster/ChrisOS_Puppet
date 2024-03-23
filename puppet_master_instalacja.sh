#!/bin/bash

# Krok 1: Pobieranie i Instalacja Puppet Server
echo "puppetmaster.local" > /etc/hostname
echo "Please reboot your VM for changes to take effect."
read -p "Press Enter to continue after rebooting..."

sudo wget https://apt.puppet.com/puppet7-release-jammy.deb
sudo dpkg -i puppet7-release-jammy.deb
sudo apt-get update
sudo apt-get install -y puppetserver
sudo systemctl enable puppetserver

# Konfiguracja Puppet Mastera : /etc/puppetlabs/puppet/puppet.conf
sudo tee /etc/puppetlabs/puppet/puppet.conf > /dev/null <<EOF
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
puppet module install puppetlabs-stdlib


# Tworzenie certyfikatu serwera master
systemctl stop puppetserver
rm -rf /etc/puppetlabs/puppet/ssl/*
rm -rf /etc/puppetlabs/puppetserver/ca/*
puppetserver ca setup
systemctl start puppetserver
puppet agent --test 

Restart Server 

# Weryfikacja Instalacji Puppet Server

puppet --version
sudo systemctl status puppetserver
