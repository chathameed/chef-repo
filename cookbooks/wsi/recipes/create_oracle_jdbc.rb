wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
datasource_script_file = "#{node['wsi']['datasource_script_file']}"
jdbc_provider_script_file = "#{node['wsi']['jdbc_provider_script_file']}"
cluster_name = "#{node['wsi']['cluster_name']}"
ds_name = "#{node['wsi']['ds_name']}"
ds_jndi_name = "#{node['wsi']['ds_jndi_Name']}"
jdbc_name = "#{node['wsi']['jdbc_name']}"
ds_auth_user = "#{node['wsi']['ds_auth_user']}"
ds_url = "#{node['wsi']['ds_url']}"
ds_user_alias = "#{node['wsi']['ds_user_alias']}"
ds_user = "#{node['wsi']['ds_user']}"
ds_pass = "#{node['wsi']['ds_pass']}"

cookbook_file "#{jdbc_provider_script_file}" do
  source 'createJDBCprovider.py'
  owner 'root'
  group 'sgsup'
  mode '755'
  action :create
end

execute 'jdbc_provider_creation' do
  command " #{wsadmin_path}/wsadmin.sh -lang #{script_lang} -f #{jdbc_provider_script_file} #{cluster_name} #{jdbc_name} "
end

cookbook_file "#{datasource_script_file}" do
  source 'datasourcecreation.py'
  owner 'root'
  group 'sgsup'
  mode '755'
  action :create
end

execute 'datasource_creation' do
  command " #{wsadmin_path}/wsadmin.sh -lang #{script_lang} -f #{datasource_script_file} #{ds_name} #{ds_jndi_name} #{jdbc_name} #{ds_auth_user} #{cluster_name}  #{ds_url}  #{ds_user_alias} #{ds_user} #{ds_pass} "
end
