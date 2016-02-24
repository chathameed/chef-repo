import os;
import sys;
import traceback;

#####################################################################
## Update Generic JVM Properties
#####################################################################

def setJVMClassPath(clusterName, enableVerboseGC, initialHeapSize, maximumHeapSize, umask):
    print "Cluster Name = " + clusterName + "\n"
    clusterID = AdminConfig.getid("/ServerCluster:" + clusterName + "/")
    serverList=AdminConfig.list('ClusterMember', clusterID)
    servers=serverList.split("\n")

    for serverID in servers:
        serverName=AdminConfig.showAttribute(serverID, 'memberName')
        print "ServerName = " + serverName + "\n"
        server=AdminConfig.getid("/Server:" +serverName + "/")
        processexec = AdminConfig.list("ProcessExecution",server)
        jvm=AdminConfig.getid("/Server:" + serverName + "/JavaProcessDef:/JavaVirtualMachine:/")
        AdminConfig.modify(jvm, [["verboseModeGarbageCollection", enableVerboseGC]])
        AdminConfig.modify(jvm, [["initialHeapSize", initialHeapSize]])
        AdminConfig.modify(jvm, [["maximumHeapSize", maximumHeapSize]])
        AdminConfig.modify(processexec, [["umask", umask]])
        AdminConfig.save()
        print "JVM Properties Updated for :" + serverName + "\n"

#################################################
# Main
#################################################
if len(sys.argv) != 5:
        print "\n Format : SetJVMClassPathForCluster.py clusterName, enableVerboseGC, initialHeapSize, maximumHeapSize, umask"
        sys.exit(1)

else:
        clusterName = sys.argv[0]
        enableVerboseGC = sys.argv[1]
        initialHeapSize = sys.argv[2]
        maximumHeapSize = sys.argv[3]
        umask = sys.argv[4]
        setJVMClassPath(clusterName, enableVerboseGC, initialHeapSize, maximumHeapSize, umask)
