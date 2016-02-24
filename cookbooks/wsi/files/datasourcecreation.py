global AdminConfig

import sys

#####################################################################
## Create JMSProvider for a given Server1
#####################################################################

def createDataSource(dsName, dsJNDIName, dsDesc, jdbcName, authUser, clusterName, url, userAlias, user, jdbcpass) :

        provider = AdminConfig.getid("/ServerCluster:" + clusterName + "/JDBCProvider:"
                       + jdbcName + "/")


        print provider
        alias = ['alias', userAlias]
        userid = ['userId', user]
        password = ['password', jdbcpass]
        jaasAttrs = [alias, userid, password]
        security = AdminConfig.getid('/Security:/')
        print 'security:'+security
        j2cUser=AdminConfig.create('JAASAuthData', security, jaasAttrs)
	AdminConfig.save()
	print 'Creating MINE User sucessfull'

        name = ['name', dsName]
        desc = ['description', dsDesc]
        jndi = ['jndiName', dsJNDIName]
        helper = ['datasourceHelperClassname', "com.ibm.websphere.rsadapter.Oracle10gDataStoreHelper"]
        authUser = ['authDataAlias', authUser]

        dsAttrs=[name, desc, jndi, helper, authUser]

        newds=AdminConfig.create('DataSource', provider, dsAttrs)
        print newds
	
	URLCreate = AdminConfig.create('J2EEResourcePropertySet', newds, [])
        AdminConfig.create('J2EEResourceProperty', URLCreate, [["name", "URL"], ["value", url]])
        AdminConfig.save()
#####################################################################

#####################################################################
# Main
#####################################################################

if (len(sys.argv) != 9):
        print "This script requires DataSourceName, JNDI Name, JDBC Name, AuthUSer, ClusterName"
        exit
else:
        dsName = sys.argv[0]
        dsJNDIName = sys.argv[1]
        jdbcName = sys.argv[2]
        authUser = sys.argv[3]
        clusterName = sys.argv[4]
        dsDesc = "New JDBC Datasource"
	url =  sys.argv[5]
	userAlias = sys.argv[6]
	user = sys.argv[7]
	jdbcpass = sys.argv[8]

ds = createDataSource(dsName, dsJNDIName, dsDesc, jdbcName, authUser, clusterName, url, userAlias, user, jdbcpass)
print "After Create DATASTORE"


