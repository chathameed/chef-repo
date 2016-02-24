wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
dyna_cache_size_script_file = "#{node['wsi']['dyna_cache_size_script_file']}"
cluster_name = "#{node['wsi']['cluster_name']}"
dyna_cache_size = "#{node['wsi']['dyna_cache_size']}"

cookbook_file "#{dyna_cache_size_script_file}" do
  source 'updatedynacache.py'
  owner was_user
  group was_group
  mode '755'
  action :create
end

execute 'Updating Dyna Cache Size' do
  command "#{wsadmin_path}/wsadmin.sh -lang #{script_lang} -f #{dyna_cache_size_script_file} #{cluster_name} #{dyna_cache_size}"
end
