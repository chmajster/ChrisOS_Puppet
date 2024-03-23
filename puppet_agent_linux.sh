#!/bin/bash

# Dodawanie wpisu do /etc/hosts
echo "192.168.1.109 puppetmaster.local" | sudo tee -a /etc/hosts

# Pobieranie i Instalacja Puppet Agent
sudo wget https://apt.puppet.com/puppet7-release-jammy.deb
sudo dpkg -i puppet7-release-jammy.deb
sudo apt-get update
sudo apt-get install -y puppet-agent

# Uruchamianie agenta Puppet przy starcie systemu
sudo puppet resource service puppet ensure=running enable=true

# Uruchamianie agenta Puppet co 30 minut
sudo puppet resource cron puppet-agent ensure=present user=root minute=30 command='/opt/puppetlabs/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60'

# Konfiguracja agenta do mastera
sudo tee /etc/puppetlabs/puppet/puppet.conf > /dev/null <<EOF
[main]
server = puppetmaster.local 
environment = production
EOF

echo "Puppet Agent has been installed and configured successfully."
