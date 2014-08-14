# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.0"

Vagrant.configure("2") do |config|
  config.vm.box = "coreos-alpha"
  config.vm.box_version = ">= 308.0.1"
  config.vm.box_url = "http://alpha.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json"

  config.vm.provider :vmware_fusion do |vb, override|
    override.vm.box_url = "http://alpha.release.core-os.net/amd64-usr/current/coreos_production_vagrant_vmware_fusion.json"
  end

  config.vm.provider :virtualbox do |v|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    v.check_guest_additions = false
    v.functional_vboxsf     = false
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  (1..3).each do |i|
    config.vm.define vm_name = "gluster-#{i}" do |config|
      config.vm.hostname = vm_name
      config.vm.network :private_network, ip: "172.21.12.#{i+9}"
      config.vm.provision :file, :source => File.join(File.dirname(__FILE__), "user-data"), :destination => "/tmp/vagrantfile-user-data"
      config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
    end
  end
end
