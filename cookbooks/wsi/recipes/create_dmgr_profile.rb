execute 'create_dmgr_profile' do
  command "	#{node[:wsi][:was_bin_path]}/WebSphere/85-64/bin/manageprofiles.sh\
     -create\
     -profileName #{node[:wsi][:dmgr_profile_name]}\
     -profilePath #{node[:wsi][:dmgr_profile_path]}\
     -templatePath #{node[:wsi][:was_bin_path]}/WebSphere/85-64/profileTemplates/dmgr/\
     -hostName #{node[:wsi][:dmgr_host_name]}\
     -nodeName #{node[:wsi][:dmgr_node_name]}\
     -cellName #{node[:wsi][:dmgr_cell_name]}\
     -adminUserName #{node[:wsi][:admin_user]}\
     -adminPassword #{node[:wsi][:admin_password]}\
     -startingPort #{node[:wsi][:dmgr_starting_port]}"
     not_if { ::File.directory? ("#{node[:wsi][:dmgr_profile_path]}")}
end

execute 'startManager' do
  command "#{node[:wsi][:dmgr_profile_path]}/bin/startManager.sh"
  not_if { ::File.exist? ("#{node[:wsi][:dmgr_profile_path]}/logs/dmgr/dmgr.pid")}
end
