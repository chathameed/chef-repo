was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
script_file = "#{node['wsi']['thredpool_script_file']}"
min_value =  "#{node['wsi']['threadpool_min_value']}"
max_value = "#{node['wsi']['threadpool_max_value']}"
server_name = "#{node['wsi']['server_name']}"
node_name = "#{node['wsi']['node_name']}"

cookbook_file "#{script_file}" do
source 'configurethreadpool.py'
owner was_user
group was_group
mode '755'
action :create
end

execute 'threadpool' do
        command " #{wsadmin_path}/wsadmin.sh -lang #{script_lang} -f #{script_file} #{server_name} #{node_name} #{min_value} #{max_value} "
end
