# cloud-init meta-data instance-id
$clound_init_uid = 1

# Change the CentOS 7 version to be installed
# Check the available versions at https://atlas.hashicorp.com/centos/boxes/7
$image_version = "1607.01"

# Enable port forwarding of Docker TCP socket
# Set to the TCP port you want exposed on the *host* machine, default is 2375
# If 2375 is used, Vagrant will auto-increment (e.g. in the case of $num_instances > 1)
# You can then use the docker tool locally by setting the following env var:
#   export DOCKER_HOST='tcp://127.0.0.1:2375'
#$expose_docker_tcp=2375

# Enable NFS sharing of your home directory ($HOME) to VM
# It will be mounted at the same path in the VM as on the host.
# Example: /Users/foobar -> /Users/foobar
$share_home=true

# Customize VMs
$vm_name = "centos-docker"
$vm_gui = false
$vm_memory = 1024
$vm_cpus = 2

# Share additional folders to the VMs
# For example,
# $shared_folders = {'/path/on/host' => '/path/on/guest', '/home/foo/app' => '/app'}
# or, to map host folders to guest folders of the same name,
# $shared_folders = Hash[*['/home/foo/app1', '/home/foo/app2'].map{|d| [d, d]}.flatten]
#$shared_folders = {'~/services-config' => '/etc/services-config', '~/services-data' => '/var/services-data', '~/services-packages' => '/var/services-packages'}
$shared_folders = {'./config' => '/etc/services-config', './data' => '/var/services-data', './packages' => '/var/services-packages'}

# Enable port forwarding from guest(s) to host machine, syntax is: { 80 => 8080 }, auto correction is enabled by default.
#$forwarded_ports = {}

# IP address of guest machine.
$ip_address = "192.168.97.100"
