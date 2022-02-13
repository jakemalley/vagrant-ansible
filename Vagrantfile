# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
  "awx"  => { :ip => "192.168.56.10", :cpus => 4, :memory => 6144, :groups => ["servers"] },
}

# create a hash of the groups in the format { "group" => [ "vm1", "vm2"... ] }
machines_ansible_groups = machines.inject(Hash.new([])) {|g,(k,vs)|vs[:groups].each {|v| g[v] += [k]}; g}

Vagrant.configure("2") do |config|

  config.vm.box = "jakemalley/centos8-stream"
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  machines.each_with_index do | (hostname, machine_config), idx |
    config.vm.define "#{hostname}" do | machine |
      machine.vm.hostname = "#{hostname}.vagrant-ansible.local"
      machine.vm.network :private_network, ip: "#{machine_config[:ip]}"

      machine.vm.provider "virtualbox" do |vb|
        vb.name = "vagrant-ansible_#{hostname}"
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
          ansible.galaxy_role_file = "provision/requirements.yml"
          ansible.groups = machines_ansible_groups
          ansible.extra_vars = {
            "k3s_interface" => "enp0s8",
            "k3s_server_node_taints" => []
          }
        end
      end
    end
  end

end
