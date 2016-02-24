import os;
import sys;
import traceback;

#####################################################################
## Update Thread Pool size
#####################################################################

def configureThreadPool(clusterName, threadPoolName, minSize, maxSize):
            print "Cluster Name = " + clusterName + "\n"
            clusterID = AdminConfig.getid("/ServerCluster:" + clusterName + "/")
            serverList=AdminConfig.list('ClusterMember', clusterID)
            servers=serverList.split("\n")

            for serverID in servers:
                serverName=AdminConfig.showAttribute(serverID, 'memberName')
                print "ServerName = " + serverName + "\n"
                server=AdminConfig.getid("/Server:" +serverName + "/")
                threadPool = AdminConfig.list("ThreadPool",server)

                for thread in threadPool.split("\n"):
                        name = AdminConfig.showAttribute(thread, "name")
                        if (name == threadPoolName):
                                AdminConfig.modify(thread, [['minimumSize', minSize],['maximumSize', maxSize]])
                                print name + " thread pool updated with minSize:" + minSize + " and maxSize:" + maxSize
                                AdminConfig.save()

#####################################################################
## Main
#####################################################################

if len(sys.argv) != 4:
        print "This script requires clusterName, threadPoolName(WebContainer/Default/ORB.thread.pool...), minSize, maxSize"
        sys.exit(1)
else:
        clusterName = sys.argv[0]
        threadPoolName = sys.argv[1]
        minSize = sys.argv[2]
        maxSize = sys.argv[3]
        configureThreadPool(clusterName, threadPoolName, minSize, maxSize)
