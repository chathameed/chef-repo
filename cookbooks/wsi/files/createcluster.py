#---------------------------------------------------------------------
#       Name: createCluster.py
#       Role: Create an empty cluster
#     Author: Robert A. (Bob) Gibson [rag]
# History
#   date    ver  who  what 
# --------  ---  ---  ----------
# 10/01/14  0.1  rag  New: created to simplify developerWorks article
#---------------------------------------------------------------------
import sys, getopt;

#---------------------------------------------------------------------
# Name: createCluster()
# Role: Placeholder for routine to perform the desired action
#---------------------------------------------------------------------
def createCluster( cmdName = 'createCluster' ) :
  missingParms = '%(cmdName)s: Insufficient parameters provided.\n';

  #-------------------------------------------------------------------
  # How many user command line parameters were specified?
  #-------------------------------------------------------------------
  argc = len( sys.argv );                   # Number of arguments
  if ( argc < 1 ) :                         # If too few are present,
    print missingParms % locals();          #   tell the user, and
    Usage( cmdName );                       #   provide the Usage info
  else :                                    # otherwise
    Opts = parseOpts( cmdName );            #   parse the command line

  #-------------------------------------------------------------------
  # 1. Assign values from the user Options dictionary, to make value
  #    access simplier, and easier.  For example, instead of using:
  #      Opts[ 'clusterName' ]
  #    we will be able to simply use:
  #      clusterName
  #    to access the value.
  # 2. Verify that each parameter is not None, and isn't an empty string
  # 3. Add a mapped error message should an error be encountered.
  #-------------------------------------------------------------------
  badReqdParam = '%(cmdName)s: Invalid required parameter: %(key)s.\n';
  for key in Opts.keys() :
    val = Opts[ key ];
    if ( not val ) or ( not val.strip() ) :
      print badReqdParam % locals();
      Usage();
    cmd = '%s=Opts["%s"]' % ( key, key );
    exec( cmd );

  #-------------------------------------------------------------------
  # Call the AdminTask.createCluster() method using the command line
  # parameter values.
  #-------------------------------------------------------------------
  print '%(cmdName)s --clusterName %(clusterName)s' % locals();
  try :
    AdminTask.createCluster( '[-clusterConfig [-clusterName %s]]' % clusterName );
    AdminConfig.save();
    print '%(cmdName)s success. Cluster %(clusterName)s created successfully.' % locals();
  except :
    #-----------------------------------------------------------------
    # An exception occurred. Convert the exception value to a string
    # using the backtic operator, then look for the presence of one of
    # the WebSphere message number, which start with 'ADMG'.  If one
    # is found, only display the last part of the value string.
    #-----------------------------------------------------------------
    val = `sys.exc_info()[ 1 ]`;
    pos = val.rfind( 'ADMG' )
    if pos > -1 :
      val = val[ pos: ]
    print '%(cmdName)s Error. %(val)s' % locals();

#---------------------------------------------------------------------
# Name: parseOpts()
# Role: Process the user specified (command line) options
#---------------------------------------------------------------------
def parseOpts( cmdName ) :
  shortForm = 'L:';
  longForm  = [ 'clusterName=' ];
  badOpt    = '%(cmdName)s: Unknown/unrecognized parameter%(plural)s: %(argStr)s\n';
  optErr    = '%(cmdName)s: Error encountered processing: %(argStr)s\n';

  try :
    opts, args = getopt.getopt( sys.argv, shortForm, longForm );
  except getopt.GetoptError :
    argStr = ' '.join( sys.argv );
    print optErr % locals();
    Usage( cmdName );

  #-------------------------------------------------------------------
  # Initialize the Opts dictionary using the longForm key identifiers
  #-------------------------------------------------------------------
  Opts = {};
  for name in longForm :
    if name[ -1 ] == '=' :
      name = name[ :-1 ]
    Opts[ name ] = None;

  #-------------------------------------------------------------------
  # Process the list of options returned by getopt()
  #-------------------------------------------------------------------
  for opt, val in opts :
    if opt in   ( '-L', '--clusterName' ) : Opts[ 'clusterName' ] = val

  #-------------------------------------------------------------------
  # Check for unhandled/unrecognized options
  #-------------------------------------------------------------------
  if ( args != [] ) :        # If any unhandled parms exist => error
    argStr = ' '.join( args );
    plural = '';
    if ( len( args ) > 1 ) : plural = 's';
    print badOpt % locals();
    Usage( cmdName );

  #-------------------------------------------------------------------
  # Return a dictionary of the user specified command line options
  #-------------------------------------------------------------------
  return Opts;

#---------------------------------------------------------------------
# Name: Usage()
# Role: Routine used to provide user with information necessary to
#       use the script.
#---------------------------------------------------------------------
def Usage( cmdName = None ) :
  if not cmdName :
    cmdName = 'createClusterMember'

  print '''Command: %(cmdName)s\n
Purpose: wsadmin script used to create a new cluster.\n
  Usage: %(cmdName)s [options]\n
Required switches/options:
  -L | --clusterName <name> = Name of cluster to be created.
\nNotes:
- Long form option values may be separated/delimited from their associated
  identifier using either a space, or an equal sign ('=').\n
- Short form option values may be sepearated from their associated letter
  using an optional space.\n
- Text containing blanks must be enclosed in double quotes.\n
Examples:
  wsadmin -f %(cmdName)s.py --clusterName=C1
  wsadmin -f %(cmdName)s.py -LC1\n''' % locals();
  sys.exit();

#---------------------------------------------------------------------
# This is the point at which execution begins
#---------------------------------------------------------------------
if ( __name__ == '__main__' ) :
  createCluster();
else :
  print 'Error: this script must be executed, not imported.\n';
  Usage();

