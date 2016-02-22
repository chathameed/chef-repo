global AdminCOnfig

import sys

def setJVMCLassPath (clusterName, classpath,  bootClasspath, initialHeapSize, maximumHeapSize, umask):
        print "\n**********************************************************************************"
        print "CLUSTERNAME = " + clusterName + "\n"

        clusterID = AdminConfig.getid("/ServerCluster:" + clusterName + "/")
        serverList=AdminConfig.list('ClusterMember', clusterID)
        servers=serverList.split("\n")

        for serverID in servers:
                serverName=AdminConfig.showAttribute(serverID, 'memberName')
                print "ServerName = " + serverName + "\n"
                server=AdminConfig.getid("/Server:" +serverName + "/")
		processexec = AdminConfig.list("ProcessExecution",server)
                jvm=AdminConfig.getid("/Server:" + serverName + "/JavaProcessDef:/JavaVirtualMachine:/")
                AdminConfig.modify(jvm, [["classpath", classpath]])
		AdminConfig.modify(jvm, [["bootClasspath", bootClasspath]])
		AdminConfig.modify(jvm, [["initialHeapSize", initialHeapSize]])
		AdminConfig.modify(jvm, [["maximumHeapSize", maximumHeapSize]])
		AdminConfig.modify(processexec, [["umask", umask]])
                AdminConfig.save()



#################################################
#
#  Make sure there are enough ARGS send into
#  the script
#
#################################################

if (len(sys.argv) != 6) :
        print "\n Format : SetJVMClassPathForCluster.py ClusterName Classpath"
        sys.exit(1)

#################################################
# Read the args
#################################################

clusterName=sys.argv[0]
classpath=sys.argv[1]
bootClasspath=sys.argv[2]
initialHeapSize=sys.argv[3]
maximumHeapSize=sys.argv[4]
umask=sys.argv[5]

setJVMCLassPath (clusterName, classpath, bootClasspath, initialHeapSize, maximumHeapSize, umask )
