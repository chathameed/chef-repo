wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
disable_cg_script_file = "#{node['wsi']['disable_cg_script_file']}"
cluster_name = "#{node['wsi']['cluster_name']}"
is_enabled = "#{node['wsi']['is_enaled']}"
is_activate_enaled = "#{node['wsi']['is_activate_enaled']}"

cookbook_file "#{disable_cg_script_file}" do
  source 'disablecoregroup.py'
  owner was_user
  group was_group
  mode '755'
  action :create
end

execute 'Disable Core group service' do
  command "#{wsadmin_path}/wsadmin.sh -lang #{script_lang} -f #{disable_cg_script_file} #{cluster_name} #{is_enabled} #{is_activate_enaled}"
end
