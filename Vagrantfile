# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'
require 'yaml'

Vagrant.require_version ">= 1.6.0"
ENV['VAGRANT_DEFAULT_PROVIDER'] = "docker"
ENV['VAGRANT_NO_PARALLEL'] = "yes"

if !Vagrant::Util::Platform.windows?
  unless Vagrant.has_plugin?("vagrant-hostsupdater")

puts <<-EOT
================================================================================
The recommended plugin vagrant-hostsupdater is not installed. This will assist 
setting up /etc/hosts entries for the guest VMs.

To install run:
vagrant plugin install vagrant-hostsupdater
--------------------------------------------------------------------------------

EOT

  end
end

$containers_config_file = File.expand_path("./containers.yml", File.dirname(__FILE__))
$docker_host_vm_vagrantfile = File.expand_path("./docker-host/Vagrantfile", File.dirname(__FILE__))
$docker_host_vm_name = "core-docker-host"

if !File.exist?($containers_config_file)
  abort("Cannot find path: %s" % $containers_config_file)
end

if !File.exist?($docker_host_vm_vagrantfile)
  abort("Cannot find path: %s" % $docker_host_vm_vagrantfile)
end

Vagrant.configure("2") do |config|
  YAML.load_file($containers_config_file).each do |containers|
    config.vm.define containers["name"] do |container|
      container.vm.synced_folder ".", "/vagrant", disabled: true
      container.ssh.username = containers["ssh_username"]
      if !containers["ssh_password"].nil? && !containers["ssh_password"].empty?
        container.ssh.password = containers["ssh_password"]
      end
      container.ssh.port = 22

      container.vm.provider "docker" do |docker|
        docker.force_host_vm = true
        docker.vagrant_vagrantfile = $docker_host_vm_vagrantfile
        docker.vagrant_machine = $docker_host_vm_name
        docker.name = containers["name"]
        docker.image = containers["image"]
        docker.ports = containers["ports"]
        if !containers["volumes"].nil? && !containers["volumes"].empty?
          docker.volumes = containers["volumes"]
        end
        docker.has_ssh = containers["has_ssh"]
        docker.remains_running = containers["remains_running"]
      end

      container.vm.post_up_message = "
Usage: 
  vagrant docker-logs %s - Inspect the container logs. Useful to find the SSH credentials for sudo.
  vagrant ssh %s - SSH to the container.
" % [containers["name"], containers["name"]]

    end

  end
end