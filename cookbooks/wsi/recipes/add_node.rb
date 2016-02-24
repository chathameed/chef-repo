execute 'add_node_to_dmgr' do
  command "#{node[:wsi][:node1_profile_path]}/bin/addNode.sh\
   #{node[:wsi][:dmgr_host_name]}\
   #{node[:wsi][:dmgr_soap_port]}"
   not_if { ::File.exist? ("#{node[:wsi][:node1_profile_path]}/logs/nodeagent/nodeagent.pid")}
end

execute 'start_node_agent' do
  command "#{node[:wsi][:node1_profile_path]}/bin/startNode.sh"
  not_if { ::File.exist? ("#{node[:wsi][:node1_profile_path]}/logs/nodeagent/nodeagent.pid")}
end
