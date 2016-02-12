#!/bin/sh

inputFile=$1

#if [ ! -f /tmp/installIHS7.dat ]
#then echo "<INFO> Input file /tmp/installIHS7.dat not found - exiting"
#exit 998
#fi

. $inputFile

# Check that CONF_ROOT is populated

APPDIR=$CONF_ROOT
if [ x"$CONF_ROOT" = x"" ];
then
echo "<ERROR>"
echo "<ERROR> CONF_ROOT is empty or missing in $inputFile - exiting"
echo "<ERROR>"
exit 998
fi

CLEN=$(echo ${CONF_ROOT} | awk '{print length($1)}')

if [ ${CLEN} -lt 2 ] ; then
echo "<ERROR>"
echo "<ERROR> CONF_ROOT length is 1 character, and does not reflect a valid path, or is the root folder, this is not an allowed configuration"
echo "<ERROR>"
exit 998
fi

# If CONF_ROOT directory doesnt exist try and create it

if [ ! -d $CONF_ROOT ]
then
echo "$CONF_ROOT not found - attempting to create"
mkdir -p $CONF_ROOT 
if [ $? -ne 0 ]
then
echo "CONF_ROOT creation failed, please resolve failure and retry"
exit 888
fi
fi
chmod 755 $CONF_ROOT 2> /dev/null

scriptloc=`which $0`
ihssecBin=`dirname $scriptloc`

export APPDIR 
TARGETDIR=$ihssecBin
export TARGETDIR
TEMPLATEDIR=$ihssecBin/XXTEMPLATEXX
export TEMPLATEDIR

#if [ x"$RELOC_DIR" = x"" ];
#then
#INSTALLDIR=/opt/IHS70013
#else
#INSTALLDIR=$RELOC_DIR
#fi

#export INSTALLDIR

#newDocRoot=$DOC_ROOT
#if [ x"$DOC_ROOT" = x"" ];
#then
#echo "<ERROR>"
#echo "<ERROR> DOC_ROOT is empty or missing in $inputFile - exiting"
#echo "<ERROR>"
#exit 998
#fi

# If DOC_ROOT directory doesnt exist try and create it

#if [ ! -d $DOC_ROOT ]
#then
#echo "$DOC_ROOT not found - attempting to create"
#mkdir $DOC_ROOT 
#if [ $? -ne 0 ]
#then
#echo "DOC_ROOT creation failed, please resolve failure and retry"
#exit 888
#fi
#fi
#chmod 755 $DOC_ROOT 2> /dev/null

export newDocRoot

logRoot=$LOG_ROOT
if [ x"$LOG_ROOT" = x"" ];
then
echo "<ERROR>"
echo "<ERROR> LOG_ROOT is empty or missing in $inputFile - exiting"
echo "<ERROR>"
exit 998
fi

# If LOG_ROOT directory doesnt exist try and create it

if [ ! -d $LOG_ROOT ]

then
echo "$LOG_ROOT not found - attempting to create"
mkdir -p $LOG_ROOT 
if [ $? -ne 0 ]
then
echo "LOG_ROOT creation failed, please resolve failure and retry"
exit 888
fi
fi
chmod 755 $LOG_ROOT 2> /dev/null

export logRoot
 
optDir=$TARGETDIR
export optDir
appRoot=$APPDIR
export appRoot
appDir=$APPDIR
export appDir
serverRoot=$INSTALLDIR
export serverRoot
templateDir=$TEMPLATEDIR
export templateDir
#tmpfile=/tmp/tmpfile.$$
#export tmpfile
