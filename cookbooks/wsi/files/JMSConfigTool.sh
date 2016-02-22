###################################################
#
# Written by Vijaya Palagani
#!/bin/ksh
####################################################

echo "Welcome to JMS Automation Menu"
        echo -e "Enter the was-bin path for your Application: \c"
	read was_bin
	echo -e "Enter the User Name for the console : \c"
        read User_Name
        echo -e "Enter the password for the console : \c"
        read -s password
        
$was_bin/wsadmin.sh -lang jython -username $User_Name -password $password -f /apps/common/jms/JMSConfigTool.py  

exit 0



