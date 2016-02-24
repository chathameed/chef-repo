# Cookbook Name:: wsi
# Attributes:: default

default['wsi']['repository'] = '/repository'
default['wsi']['was_bin_path'] = '/apps/was-bin'
default['wsi']['was_user_id'] = 'rusa'
default['wsi']['was_group_id'] = 'sgsup'

#install IIM and WAS packages
default['wsi']['iim_package'] = '/vagrant/InstallationManager.rpm'
default['wsi']['was_package'] = '/vagrant/was8554-8.5.5.4-x86_64.x86_64.rpm'
default['wsi']['tmp_input'] = '/tmp/installWAS85-64.dat'

#create dmgr profile
default['wsi']['dmgr_profile_name'] = 'vagrantDmgr'
default['wsi']['dmgr_profile_path'] = '/apps/was-apps/profiles/vagrantDmgr'
default['wsi']['dmgr_node_name'] = 'vagrantDmgrNode'
default['wsi']['dmgr_host_name'] = 'dmgr.websphere.vagrant.internal'
default['wsi']['dmgr_cell_name'] = 'vagrantDmgrCell'
default['wsi']['admin_user'] = 'vagarnt'
default['wsi']['admin_password'] = 'vagrant'
default['wsi']['dmgr_starting_port'] = '10000'
default['wsi']['wsadmin_path'] = '/apps/was-apps/profiles/vagrantDmgr/bin'

#create node profile
default['wsi']['node1_profile_name'] = 'vagrantNode1Profile'
default['wsi']['node1_profile_path'] = '/apps/was-apps/profiles/vagrantNode1Profile'
default['wsi']['node1_node_name'] = 'vagrantNode1'
default['wsi']['node1_cell_name'] = 'vagrantNode1Cell'

#add node to dmgr
default['wsi']['dmgr_soap_port'] = 'dmgr.websphere.vagrant.internal'
default['wsi']['dmgr_soap_port'] = '10003'

#create cluster
default['wsi']['create_cluster_py'] = '/repository/createcluster.py'
default['wsi']['cluster_name'] = 'vagrantCluster'
default['wsi']['script_lang'] = 'jython'

#add first cluster member
default['wsi']['cluster_firstmember_py_file'] = '/repository/createclusfirstmem.py'
default['wsi']['server_name'] = 'server1'

#add additional cluster members

#add custom JVM properties
default['wsi']['JvmPropertyScriptfile'] = '/repository/JvmProperty.py'
default['wsi']['jvmproperty'] = '/repository/JvmProperty.props'
default['wsi']['server_name'] = 'server1'
default['wsi']['node_name'] = 'vagrantNode1'

#disable core group service
default['wsi']['disable_cg_script_file'] = '/repository/disablecoregroup.py'
default['wsi']['is_enaled'] = 'false'
default['wsi']['is_activate_enaled'] = 'true'

#Update Dyna Cache Size
default['wsi']['dyna_cache_size_script_file'] = '/repository/updatedynacache.py'
default['wsi']['dyna_cache_size'] = '3500'

#Update JVM Monitoring Policy
default['wsi']['modify_monit_script_file'] = '/repository/updatemonitoringpolicy.py'
default['wsi']['startup_attempts'] = '3'
default['wsi']['ping_interval'] = '600'

#update generic JVM arguments
default['wsi']['generic_jvm_script_file'] = '/repository/genericJVM.py'
default['wsi']['cluster_name'] = 'vagrantCluster'
default['wsi']['enable_verbose_gc'] = 'true'
default['wsi']['initial_heap_size'] = '1024'
default['wsi']['maximum_heap_size'] = '1024'
default['wsi']['umask'] = '022'

#update thread pool
default['wsi']['thredpool_script_file'] = '/repository/configurethreadpool.py'
default['wsi']['threadpool_name'] = 'WebContainer'
default['wsi']['threadpool_min_value'] = '50'
default['wsi']['threadpool_max_value'] = '50'

#create oracle JDBC provider and data source
default['wsi']['datasource_script_file'] = '/repository/datasourcecreation.py'
default['wsi']['jdbc_provider_script_file'] = '/repository/createJDBCprovider.py'
default['wsi']['ds_name'] = 'testds1'
default['wsi']['ds_jndi_name'] = 'jdbc/testds1'
default['wsi']['jdbc_name'] = 'testjdbc'
default['wsi']['ds_auth_user'] = 'test/testdb'
default['wsi']['ds_url'] = 'jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=prd1901-vip.nam.nsroot.net)(PORT=1526))(ADDRESS=(PROTOCOL=TCP)(HOST=prd1902-vip.nam.nsroot.net)(PORT=1526))(ADDRESS=(PROTOCOL=TCP)(HOST=prd1903-vip.nam.nsroot.net)(PORT=1526))(LOAD_BALANCE=yes)(CONNECT_DATA=(SERVER = DEDICATED)(SERVICE_NAME=CHRDANT_TAF_SWDC)(FAILOVER_MODE=(TYPE=SELECT)(METHOD=BASIC)(RETRIES=180)(DELAY=5))))'
default['wsi']['ds_user_alias'] = 'test/testdb'
default['wsi']['ds_user'] = 'chor'
default['wsi']['ds_pass'] = 'chor'

#Update Data source Connection Pool properties
default['wsi']['jdbc_conn_pool_script_file'] = '/repository/updateDSConnectionpool.py'
default['wsi']['conn_timeout'] = '60'
default['wsi']['ds_max_conn'] = '200'
default['wsi']['ds_min_conn'] = '50'
default['wsi']['reap_time'] = '600'
default['wsi']['unused_timeout'] = '1800'
default['wsi']['aged_timeout'] = '0'
default['wsi']['purge_policy'] = 'EntirePool'
default['wsi']['statement_cache'] = '200'

#create JMS MQ Queue connection factory
default['wsi']['qcf_script_file'] = '/repository/createqcf.py'
default['wsi']['connection_factory_name'] = 'ECL_MX_CARDS'
default['wsi']['jms_jndi_name'] = 'jms/ECL_MX_CARDS'
default['wsi']['mq_qmgr_name'] = 'MXECST1D'
default['wsi']['mq_qmgr_transport'] = 'CLIENT'
default['wsi']['mq_qmgr_host_name'] = 'rmxap-dev4509.nam.nsroot.net'
default['wsi']['mq_svrconn_channel'] = 'MXCAR.SVRCONN'
default['wsi']['mq_qmgr_port'] = '1414'

#create JMS MQ Queues
default['wsi']['queue_creation_script_file'] = '/repository/createqueues.py'
default['wsi']['queue_display_name'] = 'ECL_MX_CARDS_RCVR'
default['wsi']['queue_jndi_name'] = 'jms/ECL_MX_CARDS_RCVR'
default['wsi']['queue_name'] = 'ECS.MX.TO_ECL_RPL_L1.LISTEN'
default['wsi']['queue_dmgr_name'] = 'MXECST1D'
