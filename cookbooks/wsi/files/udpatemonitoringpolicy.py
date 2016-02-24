import os;
import sys;
import traceback;

#####################################################################
## Modify JVM Monitoing policy
#####################################################################

def modifyJVMMonitoring(clusterName, startupAttempts, interval):
            print "Cluster Name = " + clusterName + "\n"
            clusterID = AdminConfig.getid("/ServerCluster:" + clusterName + "/")
            serverList=AdminConfig.list('ClusterMember', clusterID)
            servers=serverList.split("\n")

            for serverID in servers:
                    serverName=AdminConfig.showAttribute(serverID, 'memberName')
                    print "ServerName = " + serverName + "\n"
                    server=AdminConfig.getid("/Server:" +serverName + "/")
                    process = AdminConfig.list("MonitoringPolicy",server)
                    AdminConfig.modify(process, [ ["maximumStartupAttempts", startupAttempts], ["pingInterval", interval] ])
                    AdminConfig.save()
                    print "JVM Monitoring policy updated for : " +serverName + "\n"

#####################################################################
## Main
#####################################################################
if len(sys.argv) != 3:
        print "This script requires clusterName, startupAttempts , interval"
        sys.exit(1)
else:
        clusterName = sys.argv[0]
        startupAttempts = sys.argv[1]
        interval = sys.argv[2]
        modifyJVMMonitoring(clusterName, startupAttempts, interval)
