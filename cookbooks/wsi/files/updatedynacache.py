import os;
import sys;
import traceback;

#####################################################################
## Update Dynamic Cache size
#####################################################################

def modifyDynaCache(clusterName, dynaCacheSize):
            print "Cluster Name = " + clusterName + "\n"
            clusterID = AdminConfig.getid("/ServerCluster:" + clusterName + "/")
            serverList=AdminConfig.list('ClusterMember', clusterID)
            servers=serverList.split("\n")

            for serverID in servers:
                    serverName=AdminConfig.showAttribute(serverID, 'memberName')
                    print "ServerName = " + serverName + "\n"
                    server=AdminConfig.getid("/Server:" +serverName + "/")
                    process = AdminConfig.list("DynamicCache",server)
                    AdminConfig.modify(process, [ ["cacheSize", dynaCacheSize] ])
                    AdminConfig.save()
                    print "Dynamic Cache Size updated for : " +serverName + "\n"

#####################################################################
## Main
#####################################################################

if len(sys.argv) != 2:
        print "This script requires clusterName, dynaCacheSize"
        sys.exit(1)
else:
        clusterName = sys.argv[0]
        dynaCacheSize = sys.argv[1]
        modifyDynaCache(clusterName, dynaCacheSize)
