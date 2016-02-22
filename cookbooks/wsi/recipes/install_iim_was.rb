iim_package = "#{node['wsi']['iim_package']}"
was_package = "#{node['wsi']['was_package']}"
tmp_install_input = "#{node['wsi']['tmp_input']}"

cookbook_file tmp_install_input do
  source 'installWAS85-64.dat'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

rpm_package iim_package do
  action :install
end

rpm_package was_package do
  options "--relocate /opt/middleware/=#{node['wsi']['was_bin_path']} --force"
  action :install
end

bash 'was_move_cate_prop_file' do
  code <<-EOH
  cp #{node[:wsi][:was_bin_path]}/WebSphere/85-64/properties/wasprofile.properties.bak #{node[:wsi][:was_bin_path]}/WebSphere/85-64/properties/wasprofile.properties
  EOH
end
