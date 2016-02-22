# Script to update the Jvm Property values

was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
jvm_script_file = "#{node['wsi']['jvm_property_script_file']}"
server_name = "#{node['wsi']['server_name']}"
node_name = "#{node['wsi']['node_name']}"
jvm_property_file = "#{node['wsi']['jvm_property_file']}"

cookbook_file "#{jvm_script_file}" do
source 'jvmProperty.py'
owner was_user
group was_group
mode '755'
action :create
end

cookbook_file "#{jvm_property_file}" do
source 'jvmProperty.props'
owner was_user
group was_group
mode '755'
action :create
end

execute 'jvmproperty' do
        command " #{wsadminpath}/wsadmin.sh -lang #{script_lang} -f #{jvm_script_file} #{server_name} #{node_name} "
end
