# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Ubuntu 16.04-based Director and Storagedaemon
  config.vm.define "ubuntu-1604-all" do |box|
    box.vm.box = "puppetlabs/ubuntu-16.04-64-puppet"
    box.vm.box_version = "1.0.0"
    box.vm.hostname = "ubuntu-1604-all.local"
    box.vm.network "private_network", ip: "192.168.138.200"
    box.vm.provision "shell", path: "vagrant/prepare_debian.sh"
    box.vm.provision "shell", path: "vagrant/prepare_modulepath.sh"
    box.vm.provision "shell", inline: "puppet apply --modulepath /tmp/modules /vagrant/vagrant/all.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 1024
    end
  end

  # Ubuntu 14.04-based Filedaemon
  config.vm.define "ubuntu-1404-fd" do |box|
    box.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
    box.vm.box_version = "1.0.3"
    box.vm.hostname = "ubuntu-1404-fd.local"
    box.vm.network "private_network", ip: "192.168.138.201"
    box.vm.provision "shell", path: "vagrant/prepare_debian.sh"
    box.vm.provision "shell", path: "vagrant/prepare_modulepath.sh"
    box.vm.provision "shell", inline: "puppet apply --modulepath /tmp/modules /vagrant/vagrant/fd.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 768
    end
  end

  # CentOS 7-based Filedaemon
  config.vm.define "centos-7-fd" do |box|
    box.vm.box = "puppetlabs/centos-7.0-64-puppet"
    box.vm.box_version = "1.0.2"
    box.vm.hostname = "centos-7-fd.local"
    box.vm.network "private_network", ip: "192.168.138.202"
    box.vm.provision "shell", path: "vagrant/prepare_redhat.sh"
    box.vm.provision "shell", path: "vagrant/prepare_modulepath.sh"
    box.vm.provision "shell", inline: "puppet apply --modulepath /tmp/modules /vagrant/vagrant/fd.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 768
    end
  end
end
