Vagrant.configure(2) do |config|
  config.vm.define "ss03" do |ss03|
    ss03.vm.box = "ubuntu/xenial64"
    ss03.vm.box_version = "20171011.0.0"
    ss03.ssh.insert_key = 'false'
    ss03.vm.hostname = "ss03.swiftstack.idv"
    ss03.vm.network "private_network", ip: "172.28.128.43", name: "vboxnet0"
    ss03.vm.provider :virtualbox do |vb|
        vb.memory = 4096
        vb.cpus = 2
    end
  end
end
