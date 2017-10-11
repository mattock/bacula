#!/bin/sh

# Install Git if not present
apt-get update
which git || apt-get install -y git

# Setup Puppet module path
MODULEPATH="/tmp/modules"
rm -rf $MODULEPATH
mkdir -p $MODULEPATH

# Copy over Bacula module
mkdir -p "${MODULEPATH}/bacula"
cp -r /vagrant/* "${MODULEPATH}/bacula"

# Fetch dependency modules
CWD=`pwd`
cd $MODULEPATH

# Puppet-Finland modules
for module in monit packetfilter postgresql os systemd puppetagent; do
    git clone https://github.com/Puppet-Finland/$module.git $module
done

# Puppetlabs modules
for module in stdlib firewall; do
    git clone https://github.com/puppetlabs/puppetlabs-$module.git $module
done

cd $CWD

puppet apply --modulepath $MODULEPATH /vagrant/vagrant/ubuntu-1604-dir-sd.pp
