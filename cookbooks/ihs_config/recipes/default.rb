#
# Cookbook Name:: ihs_config
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ihs_docroot_dir = node[:ihs][:docroot_dir]
ihs_log_dir = node[:ihs][:log_dir]
ihs_key_file = node[:ihs][:key_file]
ihs_stash_file = node[:ihs][:stash_file]

[ihs_docroot_dir, ihs_log_dir].each do |dirname|
  directory dirname do
    mode '755'
    recursive true
    owner node[:ihs][:user]
    group node[:ihs][:group]
    action :create
  end
end

cookbook_file ihs_key_file do
  source "#{node[:ihs][:cert_CN]}.kdb"
  owner node[:ihs][:user]
  group node[:ihs][:group]
  action :create
end

cookbook_file ihs_stash_file do
  source "#{node[:ihs][:cert_CN]}.sth"
  owner node[:ihs][:user]
  group node[:ihs][:group]
  action :create
end

template "#{node[:ihs][:conf_dir]}/httpd.conf" do
  source 'httpd.conf.erb'
  action :create
  owner node[:ihs][:user]
  group node[:ihs][:group]
  mode '755'
  notifies :restart, 'service[ibm-http]', :delayed
end

template "#{node[:ihs][:conf_dir]}/ssl.conf" do
  source 'ssl.conf.erb'
  action :create
  owner node[:ihs][:user]
  group node[:ihs][:group]
  mode '755'
  notifies :restart, 'service[ibm-http]', :delayed
end

service 'ibm-http' do
  supports :restart => true, :reload => true
  action :nothing
end
