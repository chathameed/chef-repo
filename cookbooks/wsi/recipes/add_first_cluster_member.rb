clustername = "#{node['wsi']['cluster_name']}"
scriptlang = "#{node['wsi']['script_lang']}"
clusterfirstmember = "#{node['wsi']['cluster_firstmember_py_file']}"
server_name = "#{node['wsi']['server_name']}"

cookbook_file "#{clusterfirstmember}" do
source 'createclusfirstmem.py'
owner 'root'
group 'root'
mode '755'
action :create
end

execute 'clusterfirstmember' do
        command " #{node[:wsi][:dmgr_profile_path]}/bin/wsadmin.sh -lang #{scriptlang} -f #{clusterfirstmember} -L#{clustername} -n#{node[:wsi][:node1_node_name]} -m#{server_name} -tdefault"
end
