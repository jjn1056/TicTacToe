
Vagrant.configure(2) do |config|

  # Shared configuration
  config.vm.box = "ubuntu/ubuntu-core-devel-amd64"
  config.vm.network "forwarded_port", guest: 5000, host:5000
  config.ssh.forward_agent = true

  # Specific to the virtualbox provider
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 4
  end

  # Provisioning info
  config.vm.provision "shell", inline: <<-SHELL
    # clear the Bash History
    cat /dev/null > ~/.bash_history && history -c
  SHELL

end
