
# This script sets docker env from the Vagrant provision mechanism

setup = <<SCRIPT
# Stop and remove any existing containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Build an IMAGE tagged 'archlinux:wut' from Dockerfile
docker build -t archlinux:wut /vagrant

# Run a NEW CONTAINER named 'wut-ze-hell', as a daemon and rackup port (9292)
#   forwarded to the VM, from the IMAGE tagged 'archlinux:wut'
docker run -m 64m -d -p 9292:9292 --name 'wut-ze-hell' archlinux:wut
SCRIPT

Vagrant.configure('2') do |config|
  # Latest Ubuntu LTS from Phusion — Arch ici aussi ?
  # https://vagrantcloud.com/phusion/ubuntu-14.04-amd64
  # https://github.com/phusion/open-vagrant-boxes
  config.vm.box = 'phusion/ubuntu-14.04-amd64'

  # VM’s name in vagrant messages
  config.vm.define :yoda

  # VM’s hostname
  config.vm.host_name = 'yoda'

  # Setup resource as on DigitalOcean
  config.vm.provider :virtualbox do |vbox|
    vbox.memory = 512
    vbox.cpus = 1
  end

  # Rack(up) Server Port Forwarding
  config.vm.network 'forwarded_port', guest: 9292, host: 9292

  # Install latest docker
  config.vm.provision :docker

  # Setup the container when the VM is first created
  config.vm.provision 'shell', inline: setup

  # Make sure the correct container is running every time we start the VM.
  config.vm.provision 'shell', run: 'always', inline: 'docker start wut-ze-hell'
end
