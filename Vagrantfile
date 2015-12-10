Vagrant.configure("2") do |config|
	config.proxy.http = "http://webproxy.wlb2.nam.nsroot.net:8080"
	config.proxy.https = "http://webproxy.wlb2.nam.nsroot.net:8080"
    config.vm.box = "thussain/rhel7"
    config.vm.network :forwarded_port, guest: 80, host: 8888
    config.vm.provision :chef_solo do |chef|
        chef.add_recipe "apache2"
        chef.json = { :apache => { :default_site_enabled => true } }
    end
end
