import os;
import sys;
import traceback;

#####################################################################
## Disable Core group service at JVM level
#####################################################################

def modifyHAManager(nodeName, serverName, isEnabled, isActivateEnabled):
         processes = AdminConfig.list("HAManagerService").split("\n")
         for p in processes:
                 n = p.split("/")[3]
                 if (nodeName == n):
                          pn = p.split("/")[5].split("|")[0]
                          if (pn == serverName):
                                  print "---> Modifying the HA Manager on server: ",
                                  print serverName
                                  print " =====> enabled = " + isEnabled
                                  print " =====> activateEnabled = " + isActivateEnabled
                                  AdminConfig.modify(p, [ ["enable", isEnabled], ["activateEnabled", isActivateEnabled] ] )
                                  AdminConfig.save()

#####################################################################
## Main
#####################################################################
if len(sys.argv) != 4:
        print "This script requires nodeName, serverName, isEnabled, isActivateEnabled"
        sys.exit(1)
else:
        nodeName = sys.argv[0]
        serverName = sys.argv[1]
        isEnabled = sys.argv[2]
        isActivateEnabled = sys.argv[3]
        modifyHAManager(nodeName, serverName, isEnabled, isActivateEnabled)
