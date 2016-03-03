import os;
import sys;
import traceback;

#####################################################################
## Create WebSphere Environment Variable at cluster level
#####################################################################

def createSharedLibrary(clusterName, libName, isolatedLoader, libPath):

        clusterid=AdminConfig.getid('/ServerCluster:'+clusterName+'/');
        AdminConfig.create("Library",clusterid,[["name", libName],["isolatedClassLoader", isolatedLoader],["classPath", libPath]])
        print "\n Saving Configuration \n"
        AdminConfig.save()
        print "Shared Library "+libName+ " Created successfully \n"
        return

#####################################################################
## Main
#####################################################################

if len(sys.argv) != 4:
        print "This script requires clusterName, libName, isolatedClassLoader and classPath"
        sys.exit(1)
else:
        clusterName = sys.argv[0]
        libName = sys.argv[1]
        isolatedLoader = sys.argv[2]
        libPath = sys.argv[3]
createSharedLibrary(clusterName, libName, isolatedLoader, libPath)
