ihs_user = node['ihs']['user_id']
ihs_group = node['ihs']['group']
ihs_ins_script_path = node['ihs']['ins_script_path']
ihs_ins_script_name = node['ihs']['ins_script_name']
ihs_env_script_path = node['ihs']['env_script_path']
ihs_env_script_name = node['ihs']['env_script_name']
ihs_template_dir = node['ihs']['template_dir']
ihs_template_source = node['ihs']['template_source']
ihs_instance_name = node['ihs']['instance_name']
ihs_instance_port = node['ihs']['instance_port']
ihs_input_file_path = node['ihs']['input_file_path']
ihs_root = node['ihs']['root']

remote_directory ihs_template_dir do
  source ihs_template_source
  mode '755'
  action :create
end

cookbook_file ihs_env_script_path do
  source ihs_env_script_name
  mode '755'
  action :create
end

cookbook_file ihs_ins_script_path do
  source ihs_ins_script_name
  mode '755'
  action :create
end

execute "create ihs instance" do
  #cwd ihs_sec_bin
  cwd "#{ihs_root}/IHS70037"
  command "./ihs-newinst.sh\
  -n #{ihs_instance_name}\
  -p #{ihs_instance_port}\
  -u #{ihs_user}\
  -g #{ihs_group}\
  -s y\
  -i #{ihs_input_file_path}\
  -b #{ihs_root}/IHS70037"
end

template "/etc/init.d/#{ihs_instance_name}" do
   source "ibm-http.sh.erb"
   group ihs_group
   owner ihs_user
   mode "0755"
end

service ihs_instance_name do
  supports :start => true, :stop => true, :status => true, :restart => true
  action [:enable, :start]
end
