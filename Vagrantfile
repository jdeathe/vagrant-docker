# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'
require 'yaml'

Vagrant.require_version ">= 1.6.0"
ENV['VAGRANT_DEFAULT_PROVIDER'] = "docker"

$config_path = File.expand_path(
  "./config.rb",
  File.dirname(__FILE__)
)
$containers_config_path = File.expand_path(
  "./containers.yml",
  File.dirname(__FILE__)
)

# Defalut configuration options
$docker_host_vm_name = "localhost"

if File.exist?($config_path)
  require $config_path
end

if !File.exist?($containers_config_path)
  abort("Cannot find path: %s" % $containers_config_path)
end

$docker_host_vm_vagrantfile = ""
if $docker_host_vm_name != "localhost"
  $docker_host_vm_vagrantfile = File.expand_path(
    "./%s/Vagrantfile" % $docker_host_vm_name,
    File.dirname(__FILE__)
  )

  if !File.exist?($docker_host_vm_vagrantfile)
    abort("Cannot find path: %s" % $docker_host_vm_vagrantfile)
  end
end

Vagrant.configure("2") do |config|
  YAML.load_file($containers_config_path).each do |containers|
    config.vm.define containers["name"] do |container|
      container.vm.synced_folder ".", "/vagrant", disabled: true
      container.ssh.port = 22
      container.ssh.username = containers["ssh_username"]

      container.vm.provider "docker" do |docker, override|
        if $docker_host_vm_name != "localhost"
          docker.force_host_vm = true
          docker.vagrant_vagrantfile = $docker_host_vm_vagrantfile
        end
        docker.vagrant_machine = $docker_host_vm_name
        docker.name = containers["name"]
        docker.image = containers["image"]
        if !containers["has_ssh"].nil?
          docker.has_ssh = containers["has_ssh"]
        end
        if !containers["ports"].nil?
          docker.ports = containers["ports"]
        end
        if !containers["remains_running"].nil?
          docker.remains_running = containers["remains_running"]
        end
        docker.env = {
          SSH_SUDO: containers["ssh_sudo"],
          SSH_USER: containers["ssh_username"],
          SSH_USER_PASSWORD: containers["ssh_password"],
          SSH_USER_HOME: "/home/%s" % containers["ssh_username"]
        }

        # Work-around for endless "Warning: Connection refused. Retrying..."
        # Attribution: 
        #   - https://objectpartners.com/2017/08/03/test-vagrant-boxes-using-docker/
        #   - https://gist.github.com/double16/81572c74684c18ace981c21042fbc397#file-vagrantfile-rb-L18
        override.ssh.proxy_command = "docker run \
          --rm \
          --interactive \
          --link %s \
          alpine/socat \
          - TCP:%s:22,retry=10,interval=1
        " % [
          containers["name"],
          containers["name"]
        ]
      end

      container.vm.post_up_message = "
Usage: 
  vagrant docker-logs %s - Inspect the container logs. Useful to find the SSH credentials for sudo.
  vagrant ssh %s - SSH to the container.
" % [containers["name"], containers["name"]]

    end
  end
end