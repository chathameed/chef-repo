wsadmin_path = "#{node['wsi']['wsadmin_path']}"
was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
queue_creation_script_file = "#{node['wsi']['queue_creation_script_file']}"
cluster_name = "#{node['wsi']['cluster_name']}"
queue_display_name = "#{node['wsi']['queue_display_name']}"
queue_jndi_name = "#{node['wsi']['queue_jndi_name']}"
queue_name = "#{node['wsi']['queue_name']}"
queue_dmgr_name = "#{node['wsi']['queue_dmgr_name']}"

cookbook_file "#{queue_creation_script_file}" do
  source 'createqueues.py'
  owner was_user
  group was_group
  mode '755'
  action :create
end

execute 'Queues_creation' do
  command " #{wsadmin_path}/wsadmin.sh -lang #{script_lang}\
   -f #{queue_creation_script_file}\
      #{cluster_name}\
      #{queue_display_name}\
      #{queue_jndi_name}\
      #{queue_name}\
      #{queue_dmgr_name}"
end
