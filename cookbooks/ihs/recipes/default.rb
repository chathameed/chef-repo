#
# Cookbook Name:: ihs
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ihs_user = node['ihs']['user_id']
ihs_group = node['ihs']['group']
ihs_root = node['ihs']['root']
ihs_conf_root = node['ihs']['conf_root']
#ihs_sec_bin = node['ihs']['sec_root']

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

service 'iptables' do
  action :stop
end
