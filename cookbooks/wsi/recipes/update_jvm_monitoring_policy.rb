wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
modify_monit_script_file = "#{node['wsi']['modify_monit_script_file']}"
cluster_name = "#{node['wsi']['node_name']}"
startup_attempts = "#{node['wsi']['startup_attempts']}"
ping_interval = "#{node['wsi']['ping_interval']}"

cookbook_file "#{modify_monit_script_file}" do
  source 'updatemonitoringpolicy.py'
  owner was_user
  group was_group
  mode '755'
  action :create
end

execute 'Update JVM Monitoring Policy' do
  command "#{wsadmin_path}/wsadmin.sh -lang #{script_lang} -f #{modify_monit_script_file} #{cluster_name} #{startup_attempts} #{ping_interval}"
end
