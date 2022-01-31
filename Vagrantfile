# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
  "server01"  => { :ip => "192.168.58.2", :cpus => 4, :memory => 4096, :groups => ["servers"] },
  # "server02"  => { :ip => "192.168.58.3", :cpus => 4, :memory => 4096, :groups => ["servers"] },
  # "server03"  => { :ip => "192.168.58.4", :cpus => 4, :memory => 4096, :groups => ["servers"] },
  # "agent01"   => { :ip => "192.168.58.5", :cpus => 2, :memory => 2048, :groups => ["agents"] },
  # "agent02"   => { :ip => "192.168.58.6", :cpus => 2, :memory => 2048, :groups => ["agents"] },
  # "agent03"   => { :ip => "192.168.58.7", :cpus => 2, :memory => 2048, :groups => ["agents"] },
}

# create a hash of the groups in the format { "group" => [ "vm1", "vm2"... ] }
machines_ansible_groups = machines.inject(Hash.new([])) {|g,(k,vs)|vs[:groups].each {|v| g[v] += [k]}; g}

Vagrant.configure("2") do |config|

  config.vm.box = "jakemalley/centos8-stream"
  config.vm.box_version = "0.0.3"
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  machines.each_with_index do | (hostname, machine_config), idx |
    config.vm.define "#{hostname}" do | machine |
      machine.vm.hostname = "#{hostname}.ansible-k3s.local"
      machine.vm.network :private_network, ip: "#{machine_config[:ip]}"

      machine.vm.provider "virtualbox" do |vb|
        vb.name = "ansible-k3s_#{hostname}"
        vb.gui = false
        vb.cpus = machine_config[:cpus]
        vb.memory = machine_config[:memory]
      end

      # only run ansible at the end - so all machines
      # run in a single play (by default Vagrant will
      # provision each machine individually)
      if idx == machines.length - 1
        machine.vm.provision "ansible" do |ansible|
          ansible.limit = "all"
          ansible.playbook = "provision/provision.yml"
          ansible.config_file = "provision/ansible.cfg"
          ansible.groups = machines_ansible_groups
          ansible.extra_vars = {
            # node cidr - must match ips assigned to machines
            "k3s_node_cidr" => "192.168.58.0/24",
            "k3s_interface" => "enp0s8"
          }
        end
      end
    end
  end

end
