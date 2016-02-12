webagent_package = node['siteminder']['webagent_package']
webagent_bin = node['siteminder']['webagent_bin']

rpm_package webagent_package do
  options "--relocate /export/opt/SiteMinder/=#{webagent_bin} --force"
  action :install
end
