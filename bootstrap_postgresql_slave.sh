#!/bin/bash
#install epel repo
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#install entropy agent
yum install -y haveged
systemctl start haveged
systemctl enable haveged

#set correct timezone
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
systemctl restart rsyslog

#Install puppet repo
yum -y install http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
#Install puppet
yum -y install puppet-agent-1.10.12
source /etc/profile.d/puppet-agent.sh

sudo bash -c 'cat << EOF > /etc/puppetlabs/puppet/puppet.conf
[main]
vardir = /var/lib/puppet
logdir = /var/log/puppet
rundir = /var/run/puppet
ssldir = $vardir/ssl
server = puppetmaster.mdt-cmc.local

[agent]
report          = true
ignoreschedules = true
daemon          = false
environment     = production
EOF'

#Firewall prereq
yum -y remove firewalld
yum -y install iptables-services

#Apply puppet manifest
#local manifest
#/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
#manifest on puppetmaster
puppet agent -t; true
