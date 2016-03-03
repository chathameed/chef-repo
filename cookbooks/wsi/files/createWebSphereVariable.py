import os;
import sys;
import traceback;

#####################################################################
## Create WebSphere Environment Variable at cluster level
#####################################################################

def createWebSphereVariable(clusterName, variableName, variableValue, variableDesc):

        clusterid=AdminConfig.getid('/ServerCluster:'+clusterName+'/');
        variableid=AdminConfig.list('VariableMap', clusterid)
        AdminConfig.create("VariableSubstitutionEntry",variableid,[["symbolicName", variableName],["description", variableDesc],["value", variableValue]])
        print "\n Saving Configuration \n"
        AdminConfig.save()
        print "Variable "+variableName+ " Created successfully \n"
        return

#####################################################################
## Main
#####################################################################

if len(sys.argv) != 4:
        print "This script requires ClusterName, variableName, variableValue and variableDesc"
        sys.exit(1)
else:
        clusterName = sys.argv[0]
        variableName = sys.argv[1]
        variableValue = sys.argv[2]
        variableDesc = sys.argv[3]
createWebSphereVariable(clusterName, variableName, variableValue, variableDesc)
