global AdminConfig
import sys
#####################################################################
## Create JdbcProvider for a given Server1
#####################################################################
def createJDBCProvider(clusterName, jdbcName) :
        clusterId = AdminConfig.getid("/ServerCluster:" + clusterName + "/")
        name = ['name', jdbcName]
        desc = ['description', "Oracle JDBC Driver"]
        implClassName = ['implementationClassName', "oracle.jdbc.pool.OracleConnectionPoolDataSource"]
        classpath = ['classpath', "${ORACLE_JDBC_DRIVER_PATH}/ojdbc5.jar"]
        jdbcpAttrs=[name, desc, implClassName, classpath]
        newjdbc=AdminConfig.create('JDBCProvider', clusterId, jdbcpAttrs)
        AdminConfig.save()
#####################################################################
#####################################################################
# Main
#####################################################################

if len(sys.argv) != 2:
        print "This script requires ClusterName and jdbcName"
        sys.exit(1)
else:
        clusterName = sys.argv[0]
        jdbcName = sys.argv[1]
        createJDBCProvider(clusterName, jdbcName)
        print "JDBC Provider creation successful"
