# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'
require 'yaml'

Vagrant.require_version ">= 1.6.0"
ENV['VAGRANT_DEFAULT_PROVIDER'] = "docker"

$config_path = File.expand_path("./config.rb", File.dirname(__FILE__))
$containers_config_path = File.expand_path("./containers.yml", File.dirname(__FILE__))

# Defalut configuration options
$docker_host_vm_name = "core-docker"

if File.exist?($config_path)
  require $config_path
end

$docker_host_vm_vagrantfile = File.expand_path("./%s/Vagrantfile" % $docker_host_vm_name, File.dirname(__FILE__))

if !File.exist?($containers_config_path)
  abort("Cannot find path: %s" % $containers_config_path)
end

if !File.exist?($docker_host_vm_vagrantfile)
  abort("Cannot find path: %s" % $docker_host_vm_vagrantfile)
end

Vagrant.configure("2") do |config|
  YAML.load_file($containers_config_path).each do |containers|
    config.vm.define containers["name"] do |container|
      container.vm.synced_folder ".", "/vagrant", disabled: true
      container.ssh.port = 22
      container.ssh.username = containers["ssh_username"]
      # if !containers["ssh_password"].nil? && !containers["ssh_password"].empty?
      #   container.ssh.password = containers["ssh_password"]
      # end

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
        docker.env = {
          SSH_SUDO: containers["ssh_sudo"],
          SSH_USER: containers["ssh_username"],
          SSH_USER_PASSWORD: containers["ssh_password"],
          SSH_USER_HOME: "/home/%s" % containers["ssh_username"]
        }
      end

      container.vm.post_up_message = "
Usage: 
  vagrant docker-logs %s - Inspect the container logs. Useful to find the SSH credentials for sudo.
  vagrant ssh %s - SSH to the container.
" % [containers["name"], containers["name"]]

    end
  end
end