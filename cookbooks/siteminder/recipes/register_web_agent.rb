policy_server_1 = node['siteminder']['policy_server_1']
sm_user = node['siteminder']['sm_user']
sm_password = node['siteminder']['sm_password']
hostname = node['siteminder']['hostname']
hco = node['siteminder']['hco']
host_config_file = node['siteminder']['host_config_file']

template "#{node['siteminder']['ihs_conf_root']}/WebAgent.conf" do
  source 'WebAgent.conf.erb'
  action :create
  owner node['siteminder']['ihs_user']
  group node['siteminder']['ihs_group']
  mode '755'
end

bash 'register_siteminder' do
  cwd "#{node['siteminder']['webagent_lib']}"
  code <<-EOH
  source /apps/siteminder/webagent/nete_wa_env.sh
  ./smreghost -i #{policy_server_1} -u #{sm_user} -p #{sm_password} -hn #{hostname} -hc #{hco} -f #{host_config_file}
  EOH
  not_if { ::File.exists?(host_config_file) }
end
