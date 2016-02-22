global AdminConfig
import sys
#############################################################
## Update the GenericJVMArgument value
#############################################################

if (len(sys.argv) != 4):
     print "This script requires ServerName,  NodeName, Min_Thresold, Max_Thresold"
     exit
else:
        serverName=sys.argv[0]
        nodeName=sys.argv[1]
	Min_Thresold=sys.argv[2]
	Max_Thresold=sys.argv[3]

#configurethreadPool(nodeName, serverName)
threadPoolMgr=AdminConfig.getid("/Node:" + nodeName + "/Server:" + serverName + "/ThreadPoolManager:/")
threadPool=AdminConfig.list("ThreadPool", threadPoolMgr)
print threadPool
for thread in threadPool.split("\n"):
        name = AdminConfig.showAttribute(thread, "name");
        print "Thread Name " + name
        if (name == "WebContainer"):
                AdminConfig.modify(thread, [['minimumSize', Min_Thresold],['maximumSize', Max_Thresold]])
                print "Thread Name " + name

AdminConfig.save()
sync=AdminControl.completeObjectName("type=NodeSync,node=" + nodeName + ",*")
AdminControl.invoke(sync, 'invoke')
