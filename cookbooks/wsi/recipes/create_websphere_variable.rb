wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
was_variable_script_file = "#{node['wsi']['was_variable_script_file']}"
cluster_name = "#{node['wsi']['cluster_name']}"
variable_name = "#{node['wsi']['variable_name']}"
variable_value = "#{node['wsi']['variable_value']}"
variable_desc = "#{node['wsi']['variable_desc']}"

cookbook_file "#{was_variable_script_file}" do
  source 'createWebSphereVariable.py'
  owner was_user
  group was_group
  mode '755'
  action :create
end

execute 'Create WebSphere Variable' do
  command " #{wsadmin_path}/wsadmin.sh -lang #{script_lang}\
   -f #{was_variable_script_file}\
      #{cluster_name}\
      #{variable_name}\
      #{variable_value}\
      #{variable_desc}"
end
