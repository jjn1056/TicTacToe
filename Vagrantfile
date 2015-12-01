
Vagrant.configure(2) do |config|

  # Shared configuration
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest:5000, host:5000
  config.ssh.forward_agent = true

  #config.vm.synced_folder ".", "/vagrant", :mount_options => ['dmode=774','fmode=775']

  # Specific to the virtualbox provider
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 4
  end

  # Provisioning info
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get upgrade
    apt-get autoremove -y
    apt-get install -y vim
    apt-get install -y curl
    apt-get install -y git
    apt-get install -y sqlite3
    apt-get install -y ack-grep
    cd /vagrant
    make setup
  SHELL

end
