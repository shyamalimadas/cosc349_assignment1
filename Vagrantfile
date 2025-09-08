# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Define the base box for all VMs
  config.vm.box = "ubuntu/focal64"
  
  # Database VM
  config.vm.define "database" do |database|
    database.vm.hostname = "database-vm"
    database.vm.network "private_network", ip: "192.168.56.11"
    database.vm.provider "virtualbox" do |vb|
      vb.name = "todo-database-vm"
      vb.memory = "1024"
      vb.cpus = 1
    end
    database.vm.provision "shell", path: "bootstrap/database-vm.sh"
    
    # Port forwarding for external database access (development only)
    database.vm.network "forwarded_port", guest: 3306, host: 33061
  end

  # Backend API VM
  config.vm.define "backend" do |backend|
    backend.vm.hostname = "backend-vm"
    backend.vm.network "private_network", ip: "192.168.56.12"
    backend.vm.provider "virtualbox" do |vb|
      vb.name = "todo-backend-vm"
      vb.memory = "1024"
      vb.cpus = 1
    end
    backend.vm.provision "shell", path: "bootstrap/backend-vm.sh"
    
    # Port forwarding for API access
    backend.vm.network "forwarded_port", guest: 3001, host: 3001
  end

  # Frontend Web Server VM
  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=755", "fmode=644"]
  config.vm.define "frontend" do |frontend|
    frontend.vm.hostname = "frontend-vm"
    frontend.vm.network "private_network", ip: "192.168.56.13"
    frontend.vm.provider "virtualbox" do |vb|
      vb.name = "todo-frontend-vm"
      vb.memory = "1024"
      vb.cpus = 1
    end
    frontend.vm.provision "shell", path: "bootstrap/frontend-vm.sh"
    
    
    # Port forwarding for web access
    frontend.vm.network "forwarded_port", guest: 80, host: 8080
  end
end