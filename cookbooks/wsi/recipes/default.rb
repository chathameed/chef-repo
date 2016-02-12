#
# Cookbook Name:: wsi
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
repo_dir = "#{node['wsi']['repository']}"
was_bin_dir = "#{node['wsi']['was_bin_path']}"

group was_group do
  group_name was_group
  gid 20338
end

user was_user do
  uid 3006554
  gid 20338
end

[repo_dir, was_bin_dir]. each do |dir_name|
  directory dir_name do
    mode '0755'
    recursive true
    owner was_user
    group was_group
    action :create
  end
end

service 'iptables' do
  action :stop
end
