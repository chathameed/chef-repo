Vagrant.configure("2") do |config|
	config.proxy.http = "http://webproxy.wlb2.nam.nsroot.net:8080"
	config.proxy.https = "http://webproxy.wlb2.nam.nsroot.net:8080"
    config.vm.box = "boxcutter/centos64-i386"
    config.berkshelf.enabled = true
    config.vm.provision :chef_solo do |chef|
        chef.add_recipe "ihs"
    end
end
