=begin
bash 'create_node_profile' do
  code <<-EOH
	#{node[:wsi][:was_bin_path]}/WebSphere/85-64/bin/manageprofiles.sh\
   -create\
   -profileName #{node[:wsi][:node1_profile_name]}\
   -profilePath #{node[:wsi][:node1_profile_path]}\
   -templatePath #{node[:wsi][:was_bin_path]}/WebSphere/85-64/profileTemplates/managed/\
   -nodeName #{node[:wsi][:node1_node_name]}\
   -cellName #{node[:wsi][:node1_cell_name]}
  EOH
end
=end

execute 'create_node_profile' do
  command "#{node[:wsi][:was_bin_path]}/WebSphere/85-64/bin/manageprofiles.sh\
   -create\
   -profileName #{node[:wsi][:node1_profile_name]}\
   -profilePath #{node[:wsi][:node1_profile_path]}\
   -templatePath #{node[:wsi][:was_bin_path]}/WebSphere/85-64/profileTemplates/managed/\
   -nodeName #{node[:wsi][:node1_node_name]}\
   -cellName #{node[:wsi][:node1_cell_name]}"
   not_if { ::File.directory? ("#{node[:wsi][:node1_profile_path]}")}
end
