# This script sets docker env from the Vagrant provision mechanism
$setup = <<SCRIPT
# Stop and remove any existing containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Build container from Dockerfile
docker build -t wut-image /vagrant

# Run the container as daemon and forward the rack(up) port
# from within to the VM
docker run -d -p 9292:9292 --name wut-run wut-image:latest
SCRIPT

Vagrant.configure('2') do |config|
  # Latest Ubuntu LTS from Phusion
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
  config.vm.provision 'shell', inline: $setup
    
  # Make sure the correct containers are running
  # every time we start the VM.
  config.vm.provision 'shell', run: 'always', inline: 'docker start wut-run'
end
