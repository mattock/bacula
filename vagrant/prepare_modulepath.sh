#!/bin/sh
#
# Setup dependencies and bacula
#

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
    test -d $module || git clone https://github.com/Puppet-Finland/$module.git $module
done

# Puppetlabs modules
for module in stdlib firewall; do
    test -d $module || git clone https://github.com/puppetlabs/puppetlabs-$module.git $module
done

# Other modules
test -d epel || git clone https://github.com/Puppet-Finland/puppet-module-epel.git epel

cd $CWD
