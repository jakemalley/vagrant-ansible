# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
  "controller"   => { :ip => "172.16.0.10", :cpus => 2, :memory => 4096, :groups => ["ansible_controller"] },
}

Vagrant.configure("2") do |config|

  config.ssh.insert_key = false
  config.vm.box = "jakemalley/centos8"
  config.vm.synced_folder ".", "/vagrant"

  machines.each do | hostname, machine_config |
    config.vm.define "#{hostname}" do | machine |
      machine.vm.hostname = "#{hostname}.ansible.dev.local"
      machine.vm.network :private_network, ip: "#{machine_config[:ip]}"

      machine.vm.provider "virtualbox" do |vb|
        vb.name = "lab-ansible_#{hostname}"
        vb.gui = false
        vb.cpus = machine_config[:cpus]
        vb.memory = machine_config[:memory]
      end
    end
  end

  config.vm.provision "shell", path: "lab/bootstrap.sh"

  config.vm.provision "ansible_local" do |ansible|
    # create a hash of the groups in the format { "group" => [ "vm1", "vm2"... ] }
    ansible.groups = machines.inject(Hash.new([])) {|g,(k,vs)|vs[:groups].each {|v| g[v] += [k]}; g}
    ansible.playbook = "lab/provision.yml"
  end

end
