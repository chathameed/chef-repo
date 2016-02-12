service "#{node['siteminder']['ihs_instance_name']}" do
  action :stop
end

directory "#{node['siteminder']['ihs_docroot_dir']}"

execute 'copy_default_sm_files' do
  cwd "#{node['siteminder']['webagent_bin']}/webagent/"
  #command "mkdir -p #{node['siteminder']['docroot_dir']}"
  command "cp -r samples #{node['siteminder']['ihs_docroot_dir']}"
  #not_if { ::File.directory? ("#{node['siteminder']['docroot_dir']}") }
end

template "#{node['siteminder']['ihs_conf_root']}/httpd.conf" do
  source 'httpd.conf.erb'
  action :create
  owner node['siteminder']['ihs_user']
  group node['siteminder']['ihs_group']
  mode '755'
  notifies :restart, "service[#{node['siteminder']['ihs_instance_name']}]", :delayed
end

template "#{node['siteminder']['ihs_instance_root']}/start" do
  source 'start.erb'
  action :create
  owner node['siteminder']['ihs_user']
  group node['siteminder']['ihs_group']
  mode '755'
end

template "#{node['siteminder']['ihs_instance_root']}/stop" do
  source 'stop.erb'
  action :create
  owner node['siteminder']['ihs_user']
  group node['siteminder']['ihs_group']
  mode '755'
end

service "#{node['siteminder']['ihs_instance_name']}" do
  supports :restart => true, :start => true, :stop => true
  action :start
end
