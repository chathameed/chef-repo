
###################################################
# Written by Vijaya Palagani
###################################################


import os;
import sys;
import traceback;
def provider():
	print " pleae edit jms.props file as per ur requirment"
 	print "\n ***********creating JMS Provider***************\n"
	AdminTask.applyConfigProperties(['-propertiesFileName /apps/common/jms/jmsp.props -reportFileName report.txt'])
	print "\n Saving Configuration..\n"
	AdminConfig.save()
	print "\n JMS provider created \n"
	return
def createConnectionFactories():
	clusterName=raw_input(" Please enter cluster name: ")
	connectionFactoryName=raw_input(" Please enter Connection Factory Name:  ")
	jndiName = raw_input (" Please enter JNDI name:  ");
	queueMgrName = raw_input(" Please enter queue Manager name:  "); 
	transportType = raw_input(" Please enter transport type(BINDINGS|THIN):  ");
	queueMgrHostname = raw_input(" Please enter queue Manager hostname:  ");
	queueMgrSvrConnectionChannel = raw_input(" Please enter connection channel:  ");
	port = raw_input(" Please enter port number:  ");
	cftype = 'CF';
	
	clusterid=AdminConfig.getid('/ServerCluster:'+clusterName+'/');
	AdminTask.createWMQConnectionFactory(clusterid,["-name "+connectionFactoryName+" -jndiName "+jndiName+" -qmgrName "+queueMgrName+" -wmqTransportType "+transportType+" -qmgrHostname "+queueMgrHostname+" -qmgrPortNumber "+port+" -qmgrSvrconnChannel "+queueMgrSvrConnectionChannel+" -type "+cftype]);
	print "\n Saving Configuration \n"
	AdminConfig.save()
	print "/n connection factory created \n"
        return

def createQueues():
	clusterName = raw_input(" Please enter cluster name: ");
	DisplayName = raw_input(" Please enter display name of the queue:  ");
	jndiName = raw_input(" Please enter JNDI name:  ");
	queueName = raw_input(" Please enter queue name:  ");
	queueMgrName = raw_input(" Please enter queue Manager name:  "); 
	clusterid=AdminConfig.getid('/ServerCluster:'+clusterName+'/');
	
	AdminTask.createWMQQueue(clusterid,["-name "+DisplayName+" -jndiName "+jndiName+" -queueName "+queueName+" -qmgr "+queueMgrName])
	print "\n Saving Configuration /n"
        AdminConfig.save()
	print "/n Queue created \n"
        return

def createJ2CAuthAlias():
	cellName = raw_input(" Please enter cell name:  ");
	alias = raw_input(" Please enter Alias name:  ");
	user = raw_input(" Please enter user name:  ");
	password = raw_input(" Please enter password:  ");
	
	sec = AdminConfig.getid('/Cell:'+ cellName +'/Security:/');
	alias_attr = ["alias", alias]
        userid_attr = ["userId", user]
        password_attr = ["password", password]

        attrs = [alias_attr, userid_attr, password_attr]

        authdata = AdminConfig.create('JAASAuthData', sec, attrs)
	print "\n SavingConfiguration \n"
	AdminConfig.save()
	print "\n J2c authentication Alias created \n"
        return

def modifyQueues():
	clusterName = raw_input(" Please enter cluster name: ");
	clusterid=AdminConfig.getid('/ServerCluster:'+clusterName+'/')
	listMQqueue=AdminTask.listWMQQueues(clusterid)
	print "########List of Queues Available on the Cluster########\n\n";
	print listMQqueue
	changequeue = raw_input ("Please enter the complete queue name you want to change from the list above: ");
	DisplayName = raw_input("Please Enter the New Name of the Queue: ");
	jndiName = raw_input (" Please Enter New JNDI name:  ");
	queueName = raw_input ("Please Enter the New Queue name: ");

	modifyWMQQueue=AdminTask.modifyWMQQueue(changequeue,["-name "+DisplayName+" -jndiName "+jndiName+" -queueName "+queueName]);
	print "/n Saving Configuration \n"
	AdminConfig.save()
	print "/n Queus Modified \n"
        return

def modifyQCF():
        clusterName = raw_input(" Please enter cluster name: ");
        clusterid=AdminConfig.getid('/ServerCluster:'+clusterName+'/')
        listQCF=AdminTask.listWMQConnectionFactories(clusterid)
        print "########List of Connection Factories Available on the Cluster########\n\n";
        print listQCF
	changeQCF = raw_input ("Please enter the complete Connection Factory name you want to change from the list above: ");
        DisplayName = raw_input("Please Enter the New Name of the Connection Factory: ");
        jndiName = raw_input (" Please Enter New JNDI name:  ");

        modifyQCF=AdminTask.modifyWMQConnectionFactory(changeQCF,["-name "+DisplayName+" -jndiName "+jndiName]);
	print "\n saving configuration \n"
        AdminConfig.save()
	print "/n QCF modified \n"
        return

os.system('clear');
choice=0;
while(choice!=7):
        print "#########Tool for creating/configuring JMS(MQ specific) #####################\n\n";
	print "         1.JMS Provider Creation";
        print "         2. Create Connection Factories(MQ)";
        print "         3. Create Queues";
        print "         4. Create J2C Authentication Alias";
	print "         5. Modify Connection Factories(MQ)";
	print "         6. Modify Queues";
        print "         7. Exit";
        choice = input("Please enter you choice ");
	if(choice==1):
		provider();
	elif(choice==2):
                print " Creating Connection Factories";
                createConnectionFactories();
        elif(choice==3):
                print " Creating Queues";
                createQueues();
        elif(choice==4):
                print " Create J2C Authentication Data";
                createJ2CAuthAlias();
	elif(choice==5):
                print " Modify Connection Factories";
                modifyQCF();
	elif(choice==6):
                print " Modify Queues";
                modifyQueues();
        elif(choice==7):
                print " Thank you for using this tool. Exiting...";
                sys.exit(0);
        else:
                print " You have entered incorrect choice. Please input again";


