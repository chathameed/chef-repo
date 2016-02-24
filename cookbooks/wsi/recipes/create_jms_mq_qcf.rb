wsadmin_path = "#{node['wsi']['wsadmin_path']}"
script_lang = "#{node['wsi']['script_lang']}"
was_user = "#{node['wsi']['was_user_id']}"
was_group = "#{node['wsi']['was_group_id']}"
qcf_script_file = "#{node['wsi']['qcf_script_file']}"
cluster_name = "#{node['wsi']['cluster_name']}"
connection_factory_name = "#{node['wsi']['connection_factory_name']}"
jms_jndi_name = "#{node['wsi']['jms_jndi_name']}"
mq_qmgr_name = "#{node['wsi']['mq_qmgr_name']}"
mq_qmgr_transport = "#{node['wsi']['mq_qmgr_transport']}"
mq_qmgr_host_name = "#{node['wsi']['mq_qmgr_host_name']}"
mq_svrconn_channel = "#{node['wsi']['mq_svrconn_channel']}"
mq_qmgr_port = "#{node['wsi']['mq_qmgr_port']}"

cookbook_file "#{qcf_script_file}" do
  source 'createqcf.py'
  owner was_user
  group was_group
  mode '755'
  action :create
end

execute 'QCF_creation' do
  command " #{wsadmin_path}/wsadmin.sh -lang #{script_lang}\
   -f #{qcf_script_file}\
      #{cluster_name}\
      #{connection_factory_name}\
      #{jms_jndi_name}\
      #{mq_qmgr_name}\
      #{mq_qmgr_transport}\
      #{mq_qmgr_host_name}\
      #{mq_svrconn_channel}\
      #{mq_qmgr_port}"
end
