global AdminConfig

import sys

if len(sys.argv) != 2:
        print "This script requires ServerName and NodeName"
        sys.exit(1)
else:
        serverName=sys.argv[0]
        nodeName=sys.argv[1]

print serverName + " " + nodeName

server1 = AdminConfig.getid("/Node:" + nodeName + "/Server:" +serverName + "/")
print server1

jvm = AdminConfig.list("JavaVirtualMachine", server1)
print jvm
customProplist=[]
filesrc=open('/repository/JvmProperty.props','r')
while 1:
	line = filesrc.readline()
	line = line.replace('\n','')
        if not line : break
	name, value = line.split(":")
	print value +"      " +name
	customProplist.append([['name',name],['value',value]])
	print customProplist
filesrc.close()

AdminConfig.modify(jvm, [['systemProperties',customProplist]])
AdminConfig.save()

sync=AdminControl.completeObjectName("type=NodeSync,node=" + nodeName + ",*")
AdminControl.invoke(sync, 'sync')

