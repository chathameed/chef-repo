create_cluster_py_file = "#{node['wsi']['create_cluster_py']}"
clustername = "#{node['wsi']['cluster_name']}"
scriptlang = "#{node['wsi']['script_lang']}"

cookbook_file "#{create_cluster_py_file}" do
source 'createcluster.py'
owner 'root'
group 'root'
mode '755'
action :create
end

execute 'createcluster' do
        command " #{node[:wsi][:dmgr_profile_path]}/bin/wsadmin.sh -lang #{scriptlang} -f #{create_cluster_py_file} -L #{clustername}"
end
