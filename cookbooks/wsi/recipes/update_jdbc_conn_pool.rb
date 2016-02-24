wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
jdbc_conn_pool_script_file = "#{node['wsi']['jdbc_conn_pool_script_file']}"
cluster_name = "#{node['wsi']['cluster_name']}"
conn_timeout = "#{node['wsi']['conn_timeout']}"
ds_max_conn = "#{node['wsi']['ds_max_conn']}"
ds_min_conn = "#{node['wsi']['ds_min_conn']}"
reap_time = "#{node['wsi']['reap_time']}"
unused_timeout = "#{node['wsi']['unused_timeout']}"
aged_timeout = "#{node['wsi']['aged_timeout']}"
purge_policy = "#{node['wsi']['purge_policy']}"
statement_cache = "#{node['wsi']['statement_cache']}"

cookbook_file "#{jdbc_conn_pool_script_file}" do
  source 'updateDSConnectionpool.py'
  owner was_user
  group was_group
  mode '755'
  action :create
end

execute 'Update Data source Connection Pool properties' do
        command " #{wsadmin_path}/wsadmin.sh -lang #{script_lang} -f #{jdbc_conn_pool_script_file} #{cluster_name} #{conn_timeout} #{ds_max_conn} #{ds_min_conn} #{reap_time} #{unused_timeout} #{aged_timeout} #{purge_policy} #{statement_cache}"
end
