clustercreatescriptfile = "#{node['wsi']['clustercreatescriptfil']}"
Clustername = "#{node['wsi']['Clusternam']}"
scriptlang = "#{node['wsi']['scriptlang']}"
tmpinstall = "#{node['wsi']['tmpinstall']}"
clustermember = "#{node['wsi']['clustercreatememberscriptfil']}"
server02name = "#{node['wsi']['server02name']}"

###########create second member ########
execute 'createcluster' do
        command " #{node[:wsi][:profilePath]}/bin/wsadmin.sh -lang #{scriptlang} -f #{clustermember} -L#{Clustername} -m#{server02name} -n#{node[:wsi][:server01nodeName]}"
end

bash 'was_propertyfile' do
  code <<-EOH
	#{node[:wsi][:server01profilePath]}/bin/startServer.sh #{server01name}
	#{node[:wsi][:server01profilePath]}/bin/startServer.sh #{server02name}
    EOH
end
