import os;
import sys;
import traceback;

#####################################################################
## Disable Core group service at JVM level
#####################################################################

def modifyDynaCache(nodeName, serverName, dynaCacheSize):
         processes = AdminConfig.list("DynamicCache").split("\n")
         for p in processes:
                 n = p.split("/")[3]
                 if (nodeName == n):
                          pn = p.split("/")[5].split("|")[0]
                          if (pn == serverName):
                                  print "---> Modifying the Dyna Cache Size on server: ",
                                  print serverName
                                  print " =====> cacheSize = " + dynaCacheSize
                                  AdminConfig.modify(p, [ ["cacheSize", dynaCacheSize] ] )
                                  AdminConfig.save()
                                  print "Cache Size updated"

#####################################################################
## Main
#####################################################################

if len(sys.argv) != 3:
        print "This script requires nodeName, serverName, dynaCacheSize"
        sys.exit(1)
else:
        nodeName = sys.argv[0]
        serverName = sys.argv[1]
        dynaCacheSize = sys.argv[2]
        modifyDynaCache(nodeName, serverName, dynaCacheSize)
