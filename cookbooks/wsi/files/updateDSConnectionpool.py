import os;
import sys;
import traceback;

#####################################################################
## Update Data Source Connection Pool and Statement Cache Size
#####################################################################

def updateDSConnectionPool(clusterName, connTimeout, maxConn, minConn, reapTime, unusedTimeout, agedTimeout, purgePolicy, statCacheSize):
        print "Cluster Name = " + clusterName + "\n"
        clusterID = AdminConfig.getid("/ServerCluster:" + clusterName + "/")

        connectionPoolList=AdminConfig.list('ConnectionPool', clusterID)
        datasourceList=AdminConfig.list('DataSource', clusterID)

        connectionPool=connectionPoolList.split("\n")
        datasources=datasourceList.split("\n")

        for ds in datasources:
                ds_name=AdminConfig.showAttribute(ds, 'name')
                print "Data Source Name: " + ds_name
                AdminConfig.modify(ds, [ ["statementCacheSize", statCacheSize] ])
                AdminConfig.save()

        for conn in connectionPool:
                AdminConfig.modify(conn, [ ["connectionTimeout", connTimeout], ["maxConnections", maxConn], ["minConnections", minConn],
                                           ["reapTime", reapTime], ["unusedTimeout", unusedTimeout], ["agedTimeout", agedTimeout],
                                           ["purgePolicy", purgePolicy] ])
                AdminConfig.save()

        print "Data Source Connection Pool and statement Cache size updated for " +clusterName

#################################################
# Main
#################################################
if len(sys.argv) != 9:
  print "\n Format : updateDSconnectionpool.py clusterName, connTimeout, maxConn, minConn, reapTime, unusedTime, agedTimeout, purgePolicy, statCacheSize"
  sys.exit(1)

else:
        clusterName = sys.argv[0]
        connTimeout = sys.argv[1]
        maxConn = sys.argv[2]
        minConn = sys.argv[3]
        reapTime = sys.argv[4]
        unusedTimeout = sys.argv[5]
        agedTimeout = sys.argv[6]
        purgePolicy = sys.argv[7]
        statCacheSize = sys.argv[8]
        updateDSConnectionPool(clusterName, connTimeout, maxConn, minConn, reapTime, unusedTimeout, agedTimeout, purgePolicy, statCacheSize)
