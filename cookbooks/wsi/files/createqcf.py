import os;
import sys;
import traceback;

#####################################################################
## Create MQ QCF at cluster level
#####################################################################

def createConnectionFactories(clusterName, connectionFactoryName, jndiName, queueMgrName, transportType, queueMgrHostname, queueMgrSvrConnectionChannel, port
):
        cftype = 'QCF';

        clusterid=AdminConfig.getid('/ServerCluster:'+clusterName+'/');
        AdminTask.createWMQConnectionFactory(clusterid,["-name "+connectionFactoryName+" -jndiName "+jndiName+" -qmgrName "+queueMgrName+" -wmqTransportType
"+transportType+" -qmgrHostname "+queueMgrHostname+" -qmgrPortNumber "+port+" -qmgrSvrconnChannel "+queueMgrSvrConnectionChannel+" -type "+cftype]);
        print "\n Saving Configuration \n"
        AdminConfig.save()
        print "/n connection factory created \n"
        return

#####################################################################
## Main
#####################################################################

if len(sys.argv) != 8:
        print "This script requires ClusterName, Connection Factory Name, JNDI Name, QMGR name, binding type, hostname, channel and port"
        sys.exit(1)
else:
        clusterName = sys.argv[0]
        connectionFactoryName = sys.argv[1]
        jndiName = sys.argv[2]
        queueMgrName = sys.argv[3]
        transportType = sys.argv[4]
        queueMgrHostname = sys.argv[5]
        queueMgrSvrConnectionChannel = sys.argv[6]
        port = sys.argv[7]
        createConnectionFactories(clusterName, connectionFactoryName, jndiName, queueMgrName, transportType, queueMgrHostname, queueMgrSvrConnectionChannel,
port)
