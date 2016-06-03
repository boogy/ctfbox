# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "xenial64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
  config.vm.provision :shell, :path => "et_setup.sh", :privileged => false

  # config.vm.provision :shell do |shell|
  #   shell.inline = "useradd -m -s /bin/bash vagrant"
  # end

  config.ssh.username = 'ubuntu'
  config.ssh.password = 'ef360fd092f03db9cc3f8aa0' # password from original ubuntu-xenial-16.04-cloudimg
  #force Vagrant to keep the insecure key, such that we can automatically login from
  #one node to another.
  config.ssh.insert_key = false
  config.ssh.private_key_path = "#{ ENV['HOME'] }/.vagrant.d/insecure_private_key"
  config.vm.provision "file", source: "#{ ENV['HOME'] }/.vagrant.d/insecure_private_key", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision :shell, inline: "echo StrictHostKeyChecking no > /home/vagrant/.ssh/config"
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.synced_folder ".", "/home/vagrant/host-share", disabled: false

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Ubuntu64_16.04"
    vb.customize ["modifyvm", :id, "--memory", "4096"]
  end
end
