#
# Cookbook Name:: ihs_rpm_install
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ihs_root = node[:ihs][:root]
ihs_conf_root = node[:ihs][:conf_root]
ihs_sec_bin = node[:ihs][:sec_root]
ihs_bin_rpm = node[:ihs][:binary_rpm]
ihs_plugin_rpm = node[:ihs][:plugin_rpm]
ihs_sec_rpm = node[:ihs][:sec_rpm]
ihs_input_file_path = node[:ihs][:input_file_path]
ihs_input_file_name = node[:ihs][:ihs_input_file_name]
ihs_instance_name = node[:ihs][:instance_name]
ihs_instance_port = node[:ihs][:instance_port]
ihs_user = node[:ihs][:user_id]
ihs_group = node[:ihs][:group]

group ihs_group do
  group_name ihs_group
  gid 20338
end

user ihs_user do
  uid 3006554
  gid 20338
end

[ihs_root, ihs_conf_root]. each do |dirname|
  directory dirname do
    mode '755'
    recursive true
    owner ihs_user
    group ihs_group
    action :create
  end
end

cookbook_file ihs_input_file_path do
  source ihs_input_file_name
  owner ihs_user
  group ihs_group
  action :create
end

[ihs_bin_rpm, ihs_plugin_rpm, ihs_sec_rpm]. each do |rpm_name|
  rpm_package rpm_name do
    action :install
  end
end

execute "create ihs instance" do
  cwd ihs_sec_bin
  command "./ihs-newinst.sh -n #{ihs_instance_name} -p #{ihs_instance_port} -u #{ihs_user} -g #{ihs_group} -s y -i #{ihs_input_file_path} -b #{ihs_root}/IHS70037"
end

template "/etc/init.d/#{ihs_instance_name}" do
   source "ibm-http.sh.erb"
   group ihs_group
   owner ihs_user
   mode "0755"
end

service ihs_instance_name do
  supports :start => true, :stop => true, :status => true
  action [:enable, :start]
end
