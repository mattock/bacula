# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Ubuntu 16.04-based Director and Storagedaemon
  config.vm.define "ubuntu-1604-dir-sd" do |box|
    box.vm.box = "puppetlabs/ubuntu-16.04-64-puppet"
    box.vm.box_version = "1.0.0"
    box.vm.hostname = "ubuntu-1604-dir-sd.local"
    box.vm.network "private_network", ip: "192.168.138.200"
    box.vm.provision "shell", path: "vagrant/ubuntu-1604-dir-sd.sh"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 1024
    end
  end
end
