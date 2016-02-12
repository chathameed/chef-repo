#!/bin/ksh
#
##############################################################################################
###
###  Name : ihs-newinst
###  Version :0.1 
###  Created by: Tyrone Smith
###  Decription: This script create a new Instance for IHS
###  History:
###  When    Who               What
###  20/2/11 Sada Ragheta      Initial release for testing
###  10/3/11 Daniel Pearson    Update for relocation options and input file
###  05/4/11 Daniel Pearson    Update for specified inputs file
###  25/10/11 Dave Horsey      Update for SOP requirements
###  08/06/12 Dave Horsey      Bug fix and adding ability to pass in redirect hostname:port
###  04/12/12 Dave Horsey      Added non-zero exit code to ScriptUsage to force "error condition" 
###
##############################################################################################
#


####################################################
#indexerror
####################################################
indexerror () {

echo "<html>
<head><h1>Error Message:</h1></head>
<title> This is Error Page </title>
<body>
<br><br><h3>Index file is not found in Document Root direcotry.</h3>
</body>
</html> " > $optDir/$newInst/config/error.html

}

#####################################
# ScriptUsage
#####################################
ScriptUsage () {
   echo "
   -n     Name of the web instance or application 
   -p     Port number for web server        
   -u     User name to run web servers
   -g     Group name to run web servers if you want other than nobody
   -o     <Optional> Operations ID - this ID will own the configuration folder and must be distinct from the user name, but belong to the same group
   -s     do you want to restart the web server postconfiguration (y/n) 
   -i     Input file for instance variables
   -b     Full path to IHS binary files
   -r     Redirect url, this should be in the form of https://ServerName:port - not mandatory

   usage: ihs-newinst -n Name -p Port [-u User] [-g Group] [-o OpID] [-s y/n] -i <dat file> -b <IHS bin root> [ -r <redirect url> ]
   eg: ihs-newinst -n test -p 30066 -u test -g testgroup -o testop -s y -i /var/IHS/myvars.dat -b /opt/IHS70033 -r https://server.nam.nsroot.net:12345
   "
# added non-zero exit to ensure that any failure conditions where syntax is dumped to screen are picked up as errors - DH 12/2012
   exit 1
}
# DMP set in input file now   -d     Document directory for web servers

#######################################
#Main
##########################################
#checking for root
UserId=`id`
UserId=${UserId%%\)*}
UserId=${UserId#*\(}
if [ "$UserId" != "root" ]; then
     echo "You must be root to use this script or command!"
     exit
fi

if [[ $1 == "" ]]; then
  ScriptUsage
fi

tmpfile=/tmp/tmpfile.$$
export tmpfile

while [[ $1 = -* ]]; do
  case $1 in
    -n ) newInst=$2
         echo $newInst >> $tmpfile
         ;;
    -p ) newPort=$2
         echo $newPort >> $tmpfile
         ;;
    -u ) newUser=$2
         echo $newUser >> $tmpfile
         ;;
    -g ) newGroup=$2
         echo $newGroup >> $tmpfile
         ;;
    -o ) newOp=$2
         echo $newOp >> $tmpfile
         ;;
    -b ) binRoot=$2
         echo $binRoot >> $tmpfile
         ;;
    -i ) inputFile=$2
         echo "$inputFile" >> $tmpfile
         ;;
    -s ) ServerStart=$2
         echo $ServerStart >> $tmpfile
         ;;
    -r ) reUrl=$2
         echo $reUrl >> $tmpfile
         ;;
     * ) ScriptUsage 
    esac
    shift
    shift
done

# DMP check input file value passed and that it exists...



if [[ -z "$inputFile" ]]; then
   echo "<ERROR> -i There is no input file specified"
   ScriptUsage
fi

if [ ! -f $inputFile ]
then
    echo "<ERROR> -i input file [$inputFile] not found - Aborting"
    ScriptUsage
fi
# DMP - add check for the -b setting
if [ -z "$binRoot" ]; then
   echo "<ERROR> -b IHS Binary location not specified"
   ScriptUsage
else
echo "<INFO> -b $binRoot specified"
fi
if [ ! -f $binRoot/bin/httpd ]; then
   echo "<ERROR> -b $binRoot does not contain a valid IHS installation, please check and respecify" 
   ScriptUsage
else
INSTALLDIR=$binRoot
fi 

# DMP Get values used in this script from the env script

scriptloc=`which $0`
ihssecBin=`dirname $scriptloc`

. $ihssecBin/setIHSEnv.sh $inputFile

# Belt n braces catchall for the env script
if [ $? = 998 ];
then
echo "<ERROR> Exiting"
exit 99
fi  

tempvalue=`grep "^-" $tmpfile`
#tempNewInst="$newInst-$newPort"
# DMP - remove port from new instance name
tempNewInst="$newInst"
#Defdocdir="$APPDIR/$tempNewInst/web"
newDocRoot="$APPDIR/$tempNewInst/web"

rm $tmpfile
if [[ ! $tempvalue = "" || -z $newInst ]]; then
   ScriptUsage
fi

if [[ -z "$newPort" ]]; then
   echo "MESSAGE: There is no port number."
   ScriptUsage
elif [[ $newPort -le 1024 ]] ; then
   echo "MESSAGE: Port is less than 1024, and will require root to start the instance"
fi

#newDocRoot=${newDocRoot:-${Defdocdir}}
#newInst="${newInst}-${newPort}"
# DMP - remove port from new instance name
newInst="${newInst}"

hName=`hostname`
HostName=`nslookup $hName | awk '$1 == "Name:" {print $2}'`
hostName=`echo $HostName |cut -d" " -f2`
if [[ -z "$hostName" ]]; then
	hostName=$hName
fi

if [[ -z "$newUser" ]]; then
echo "User not supplied"
ScriptUsage
else
	if [[ "${newUser}" = "root" ]] ; then
		echo "User = root is not an allowed configuration"
		ScriptUsage
	fi

	id ${newUser} 1>&2 > /dev/null

	if [ $? -ne 0 ] ; then

		echo "<ERROR> User $newUser is not a valid user on this host, please confirm that the userid is a valid value"

		exit 1

	fi
fi

if [[ -z "$newGroup" ]]; then

	if [[ ! -z "$newOp" ]] ; then

		echo "OperationsId specified, this requires that the groupid be set and be a common group for both"
                echo "the functionalid and the operationsid"
		ScriptUsage

	fi

echo "Group not supplied - using default of nobody"
newGroup=nobody
fi

# additional checks to allow for second functionalid

if [[ ! -z "$newOp" ]] ; then

# operational id has been passed in
	# check the id is not "root"
        if [[ "${newOp}" = "root" ]] ; then
                echo "Operations User = root is not an allowed configuration"
                ScriptUsage
        fi

	# check the id is valid on the host
        id ${newOp} 1>&2 > /dev/null

        if [ $? -ne 0 ] ; then

                echo "<ERROR> User $newOp is not a valid user on this host, please confirm that the userid is a valid value"

                exit 1

        fi

	# check that newUser and newOp are not the same

	if [ "${newUser}" = "${newOp}" ] ; then

		echo "Both functional id and operations id are set to the same value, if this instance does not require a separate operations id, please do not use the -o option"
		ScriptUsage

	fi
	# check that both the newUser and newOp id's belong to the group

	group=$newGroup

	glist1=$(id ${newUser} | awk '{print $3}' | cut -d= -f2)
	glist2=$(id ${newOp} | awk '{print $3}' | cut -d= -f2)

	echo ${glist1} | grep "(${group})" 1>&2 >/dev/null

	if [ $? -eq 0 ] ; then

		echo ${glist2} | grep "(${group})" 1>&2 >/dev/null

		if [ $? -ne 0 ] ; then

			echo "Operations User ${newOp} is not a member of group ${group}, this will break the dual id config"
			ScriptUsage

		fi

	else

		echo "Functional id ${newUser} is not a member of group ${group}, this will break the dual id config"

	fi
fi

if [[ -d $appDir/$newInst ]]; then
  echo "$appDir/$newInst Web server instance already exists!."
  echo "Please try with different name."
  return
fi

mkdir -p $appDir/$newInst
cp -R $templateDir/* $appDir/$newInst
if [ -d ${newDocRoot} ] ;then
	DREx=1
else
	DREx=0
fi



FILES="conf/httpd.conf"

for filename in $FILES
do
sed \
-e "s/NEWINST/$newInst/g" \
-e "s/NEWPORT/$newPort/g" \
-e "s/NEWUSER/$newUser/g" \
-e "s/NEWGROUP/$newGroup/g" \
-e "s@NEWDOCROOT@$newDocRoot@g" \
-e "s@SERVERROOT@$serverRoot@g" \
-e "s@APPROOT@$appRoot@g" \
-e "s@LOGROOT@$logRoot@g" \
-e "s/NEWHOST/$hostName/g" $appDir/$newInst/$filename > $appDir/$newInst/$filename.mod

mv $appDir/$newInst/$filename.mod $appDir/$newInst/$filename
done

FILES="conf/ssl.conf"

for filename in $FILES
do

sed \
-e "s/NEWINST/$newInst/g" \
-e "s/NEWPORT/$newPort/g" \
-e "s/NEWGROUP/$newGroup/g" \
-e "s/NEWUSER/$newUser/g" \
-e "s@NEWDOCROOT@$newDocRoot@g" \
-e "s@SERVERROOT@$serverRoot@g" \
-e "s@APPROOT@$appRoot@g" \
-e "s@LOGROOT@$logRoot@g" \
-e "s/NEWHOST/$hostName/g" $appDir/$newInst/$filename > $appDir/$newInst/$filename.mod

mv $appDir/$newInst/$filename.mod $appDir/$newInst/$filename
done

FILES="start status stop"
for filename in $FILES
do
sed \
-e "s@SERVERROOT@$serverRoot@g" \
-e "s@APPROOT@$appRoot@g" \
-e "s@LOGROOT@$logRoot@g" \
-e "s/NEWINST/$newInst/g" $appDir/$newInst/$filename > $appDir/$newInst/$filename.mod
mv $appDir/$newInst/$filename.mod $appDir/$newInst/$filename
chmod +x $appDir/$newInst/$filename
done

if [[ ! -z $reUrl ]]; then
  cd $appDir/$newInst/conf
  cp httpd.conf httpd.conf.rewrite

  sed -e '/rewrite_module/s/^#//'  httpd.conf >> temp4321
  line1="RewriteEngine On"
  line2="RewriteRule ^(.*)$  ${reUrl}\$1 [R=301,L]"

  awk '$0 ~ /TraceEnable/ {print $0; printf "\n# added for https redirect\n%s\n%s\n" , line1, line2}
       $0 !~ /TraceEnable/ {print $0}' line1="${line1}" line2="${line2}" temp4321 > temp1234

  echo "y" | cp temp1234 httpd.conf 1>&2 >/dev/null
  rm -f temp1234 temp4321


fi

#Log management
if [[ -d $logRoot/$newInst/logs ]]; then
	echo "Warning logdirectory exists.  Please check for instance creation conflicts."
else
	echo "Creating $logRoot/$newInst/logs ..."
	mkdir -p $logRoot/$newInst/logs 
fi
# DMP - Altered as the group and user being the same doesnt really happen
# DH  - moved perm changes to take account of the various options around ownership which are in place from 70021
#chown -R $newUser:$newUser $logRoot/$newInst/logs
#chown -R $newUser:$newGroup $logRoot/$newInst/logs
#chmod -R 750 $logRoot/$newInst/logs
#if [ ${DREx} -eq 0 ] ; then
#	echo "Permissioning the docroot"
#	chown -R $newUser:$newGroup $newDocRoot
#	chmod -R 750 $newDocRoot
#else
#	echo "Docroot perms will not be changed as the folder already existed, please ensure perms allow $newUser to access"
#fi
#
cp -p $inputFile $appDir/$newInst/conf/

#DH - added to set perms on the conf
# if the user isn't root or nobody we chown the conf to user:group
# otherwise leave as root

if [ "${newUser}" != "nobody" ] ; then

	if [ ! -z "$newOp" ] ; then

        chown -R $newOp:$newGroup $appDir/$newInst
        chmod -R 750 $appDir/$newInst

	else

        chown -R $newUser:$newGroup $appDir/$newInst
        chmod -R 750 $appDir/$newInst

	fi

	chown -R $newUser:$newGroup $logRoot/$newInst/logs
	chmod -R 750 $logRoot/$newInst/logs

	if [ ${DREx} -eq 0 ] ; then
        	echo "Permissioning the docroot"
	        chown -R $newUser:$newGroup $newDocRoot
        	chmod -R 750 $newDocRoot
	else
        	echo "Docroot perms will not be changed as the folder already existed, please ensure perms allow $newUser to access"
	fi

else

        chmod -R 750 $appDir/$newInst
        chmod 755 $appDir
        chmod 755 $appDir/$newInst
        chmod 755 $appDir/$newInst/conf
	chmod -R 755 $logRoot/$newInst/logs
	if [ ${DREx} -eq 0 ] ; then
        echo "Permissioning the docroot"
        #chown -R $newUser:$newGroup $newDocRoot
        chmod -R 755 $newDocRoot
	else
        echo "Docroot perms will not be changed as the folder already existed, please ensure perms allow $newUser to access"
	fi

fi

if [[ $ServerStart = "y" || $ServerStart = "Y" ]]; then
if [ "${newUser}" = "nobody" ] ; then
  $appDir/$newInst/start
  serverStart="y"
else
  su ${newUser} "-c $appDir/$newInst/start"
  serverStart="y"
fi
else
  serverStart="n"
fi
# DMP - Final step to backup the input file used to create this instance

# Setup auto start/stop script
CONF_ROOT_S=`echo $CONF_ROOT | sed 's!/!_!g'`

OS=`uname`
if [[ $OS != "AIX" && $OS != "Linux" ]]
then
echo "$OS not AIX or Linux - not setting up startup scripts"
exit
fi

if [ $OS = "AIX" ]
then
RC=/etc/rc.d/rc2.d
fi

if [ $OS = "Linux" ]
then
RC=/etc/rc.d/rc3.d
fi

echo "Copying startup scripts for" $OS

FILES="S999"
for filename in $FILES
do
sed \
-e "s@XXXX_INSTALLDIR_XXXX@$INSTALLDIR@g" \
-e "s@XXXX_LOG_DIR_XXXX@$LOG_ROOT@g" \
-e "s@XXXX_CONF_ROOT_XXXX@$CONF_ROOT@g" $appDir/$newInst/$filename > $appDir/$newInst/$filename.mod
mv $appDir/$newInst/$filename.mod $appDir/$newInst/$filename

if [  x$RC != "" ]
then

if [ -f $RC/S999$CONF_ROOT_S ]
then
echo "Start scripts already there"
else
cp $appDir/$newInst/$filename $RC/S999$CONF_ROOT_S
chmod +x $RC/S999$CONF_ROOT_S
fi

if [ -f $RC/K05$CONF_ROOT_S ]
then
echo "Stop scripts already there"
else
cp $appDir/$newInst/$filename $RC/K05$CONF_ROOT_S
chmod +x $RC/K05$CONF_ROOT_S
fi

else
echo "Startup scripts not copied - please setup manually see $appDir/$newInst/$filename for an example"
fi
# Tidy up file
rm $appDir/$newInst/S999
done

# create necessary locale for ESM

ESMDir=/etc/opt/esmsym

if [ ! -d ${ESMDir} ] ; then

	echo "<WARN> ${ESMDir} does not exist, ESM monitoring of binary installs will not function"

	echo "<INFO> Creating ${ESMDir}"

	mkdir -p ${ESMDir}

	if [ $? -ne 0 ] ; then

		echo "<ERROR> Unable to create ${ESMDir} please contact *CCC Global GT CATE Web Server Eng IHS for assistance"
		exit 1
	fi

fi

NameBase="conf_"
count=1
new=0
here=$(pwd)
exitv=0
cd ${ESMDir}

ls -l | grep " ${appDir}$" 1>&2 >/dev/null

if [ $? -ne 0 ] ; then
conexist=1
curr=$(ls -1 | grep conf_ | awk 'BEGIN{count=0}{count++}END{print count}')
else
conexist=0
fi

if [ $conexist -ne 0 ] ; then

	let "new=curr + 1"
	newc="${NameBase}${new}"
	while [ ${exitv} -eq 0 ] ; do

	ls -1 | grep conf_ | grep ${newc} 1>&2 >/dev/null

	if [ $? -ne 0 ] ; then

		# doesn't exist

		ln -s ${appDir} ${newc}

		exitv=1

	else
		let "new=new + 1"
                newc="${NameBase}${new}"
		continue

	fi

	done

fi
# write values for servercontrol tool
echo "$(date) added ${newPort} $newInst ${appDir} $appDir/$newInst/start $appDir/$newInst/stop $appDir/$newInst/status" >> ihs_ids

cd ${here}
