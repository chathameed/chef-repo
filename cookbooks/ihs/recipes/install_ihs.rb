ihs_user = node['ihs']['user_id']
ihs_group = node['ihs']['group']
ihs_bin_rpm = node['ihs']['binary_rpm']
ihs_plugin_rpm = node['ihs']['plugin_rpm']
#ihs_sec_rpm = node['ihs']['sec_rpm']
ihs_input_file_name = node['ihs']['ihs_input_file_name']
ihs_input_file_path = node['ihs']['input_file_path']

cookbook_file ihs_input_file_path do
  source ihs_input_file_name
  owner ihs_user
  group ihs_group
  action :create
end

[ihs_bin_rpm, ihs_plugin_rpm]. each do |rpm_name|
  rpm_package rpm_name do
    action :install
  end
end
