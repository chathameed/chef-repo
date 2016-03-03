wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
shared_lib_script_file = "#{node['wsi']['shared_lib_script_file']}"
cluster_name = "#{node['wsi']['cluster_name']}"
lib_name = "#{node['wsi']['lib_name']}"
lib_path = "#{node['wsi']['lib_path']}"
is_isolated_loader = "#{node['wsi']['is_isolated_loader']}"

cookbook_file "#{shared_lib_script_file}" do
  source 'createSharedLibrary.py'
  owner was_user
  group was_group
  mode '755'
  action :create
end

execute 'Create WebSphere Shared Library' do
  command " #{wsadmin_path}/wsadmin.sh -lang #{script_lang}\
   -f #{was_variable_script_file}\
      #{cluster_name}\
      #{lib_name}\
      #{lib_path}\
      #{is_isolated_loader}"
end
