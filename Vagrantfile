# Change to NAT if needed (BRIDGE is default)
#BUILD_MODE = ENV['BUILD_MODE'] || "BRIDGE" 
IP_NW = "192.168.56"
MASTER_IP_START = 10
NODE_IP_START = 20

# Function to get the default network interface handels both windows and linux
#def default_bridge_interface
#  `ip route | grep default | awk '{ print $5 }'`.chomp
#end

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-12"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048 #4096
    vb.cpus = 2
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
  end
  #config.vm.provider :virtualbox do |vb|
  #end

  config.vm.define "control-plane" do |node|
    node.vm.hostname = "control-plane"

    node.vm.network 'private_network', ip: '192.168.56.11'
    node.vm.network 'forwarded_port', guest: 6443, host: 6443
    node.vm.network 'forwarded_port', guest: 80, host: 8080
# weird port conflicts prevent https mapping on this workstation
    node.vm.network 'forwarded_port', guest: 443, host: 8443

    node.vm.provision "shell" do |s|
      s.name = "bootstrap-salt"
      s.path = "scripts/bootstrap_salt.sh"
      s.privileged = true
    end

    node.vm.provision "shell" do |s|
      s.name = "swapoff"
      s.path = "scripts/swapoff.sh"
      s.privileged = true
    end
  end



  (1..2).each do |i|
    hostname = "node-#{'%02d' % i}"
    config.vm.define "#{hostname}" do |node|
      node.vm.hostname = "#{hostname}"

      node.vm.network "private_network", ip: "#{IP_NW}.#{NODE_IP_START + i}"

      node.vm.provider "virtualbox" do |vb|
        vb.cpus = 1
        vb.memory = 2048
      end


      node.vm.provision "shell" do |s|
        s.name = "bootstrap-salt"
        s.path = "scripts/bootstrap_salt.sh"
        s.privileged = true
      end

      node.vm.provision "shell" do |s|
        s.name = "swapoff"
        s.path = "scripts/swapoff.sh"
        s.privileged = true
      end  
    end
  end
end
