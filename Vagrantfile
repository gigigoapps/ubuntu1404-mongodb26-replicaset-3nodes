# -*- mode: ruby -*-
# vi: set ft=ruby :

## Vagrant :: Ubuntu 14.04 + MongoDB 2.6 with Replica Set of 3 nodes :: Vagrant File ##

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config| 

    # Base box
    config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
    config.vm.box_version = "1.0.1"

    # Node config in a loop
	(1..3).each do |i|
	    config.vm.define "node#{i}" do |node_conf|
	        node_conf.vm.network :private_network, ip: "10.11.12.#{i + 10}"

	        node_conf.vm.hostname = "node#{i}"

	        node_conf.vm.provider 'virtualbox' do |v|
	            v.customize ['modifyvm', :id, '--groups', '/rstest']
	            v.customize ['modifyvm', :id, '--name', "node#{i}"]
	            v.customize ['modifyvm', :id, '--cpus', '1']
	            v.customize ['modifyvm', :id, '--memory', 512]
	            v.customize ['modifyvm', :id, '--ioapic', 'off']
	            v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
	            v.customize ['modifyvm', :id, '--nictype1', 'virtio']
	            v.customize ['modifyvm', :id, '--nictype2', 'virtio']
	        end

	        # Update package list
	        node_conf.vm.provision :shell, :inline => 'if [[ ! -f /apt-get-run ]]; then apt-get update && sudo touch /apt-get-run; fi'

	        # Puppet provision
	        node_conf.vm.provision :puppet do |puppet|
	            puppet.manifests_path   = 'manifests'
	            puppet.manifest_file    = 'node.pp'
	            puppet.module_path      = 'modules'
	            puppet.options          = ['--verbose']
	        end
	    end
	end
end
