import os;
import sys;
import traceback;

#####################################################################
## Create MQ Queues at cluster level
#####################################################################

def createQueues(clusterName, DisplayName, jndiName, queueName, queueMgrName):
        clusterid=AdminConfig.getid('/ServerCluster:'+clusterName+'/');

        AdminTask.createWMQQueue(clusterid,["-name "+DisplayName+" -jndiName "+jndiName+" -queueName "+queueName+" -qmgr "+queueMgrName])
        print "\n Saving Configuration /n"
        AdminConfig.save()
        print "/n Queue created \n"
        return

#####################################################################
## Main
#####################################################################

if len(sys.argv) != 5:
        print "This script requires ClusterName, Queue display name, queue JNDI Name, queue name, and qmgr name"
        sys.exit(1)
else:
        clusterName = sys.argv[0]
        DisplayName = sys.argv[1]
        jndiName = sys.argv[2]
        queueName = sys.argv[3]
        queueMgrName = sys.argv[4]
createQueues(clusterName, DisplayName, jndiName, queueName, queueMgrName)
