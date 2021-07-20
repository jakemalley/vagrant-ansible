# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
  "awx"          => { :ip => "172.16.0.10", :cpus => 4, :memory => 4096, :groups => ["ansible_controller"] },
  "target01"     => { :ip => "172.16.0.11", :cpus => 2, :memory => 4096, :groups => ["ansible_target"] },
}

# create a hash of the groups in the format { "group" => [ "vm1", "vm2"... ] }
machines_ansible_groups = machines.inject(Hash.new([])) {|g,(k,vs)|vs[:groups].each {|v| g[v] += [k]}; g}

Vagrant.configure("2") do |config|

  config.ssh.insert_key = false
  config.vm.box = "jakemalley/centos8-stream"
  config.vm.box_version = "0.0.1"
  config.vm.synced_folder ".", "/vagrant", disabled: true

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

      # only provision the controller
      if ! hostname.match(/target/)
        config.vm.synced_folder "lab/", "/opt/provision"
        config.vm.synced_folder "code/", "/var/lib/awx/projects"

        machine.vm.provision "shell", path: "lab/bootstrap.sh"

        machine.vm.provision "ansible_local" do |ansible|
          ansible.provisioning_path = "/opt/provision"
          ansible.groups = machines_ansible_groups
          ansible.extra_vars = {
            "vagrant_machines": machines,
            "machines_ansible_groups": machines_ansible_groups
          }
          ansible.become = true
          ansible.playbook = "provision.yml"
          ansible.galaxy_role_file = "requirements.yml"
          ansible.galaxy_roles_path = "/etc/ansible/roles"
          ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path}"
        end
      end
    end
  end

end
