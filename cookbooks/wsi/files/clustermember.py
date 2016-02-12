#---------------------------------------------------------------------
#       Name: createClusterMember.py
#       Role: Example script, created from scratch.
#     Author: Robert A. (Bob) Gibson [rag]
# History
#   date    ver  who  what 
# --------  ---  ---  ----------
# 09/12/19  0.4  rag  cleanup
# 09/12/18  0.3  rag  Add: command line verification & call to AdminTask
# 09/12/17  0.2  rag  Add: parseOpts() and update Usage()
# 09/12/15  0.1  rag  New: Framework - execute vs. import test and
#                          initial Usage() information
#---------------------------------------------------------------------
import sys, getopt;

#---------------------------------------------------------------------
# Name: createClusterMember()
# Role: Placeholder for routine to perform the desired action
#---------------------------------------------------------------------
def createClusterMember( cmdName = 'createClusterMember' ) :
  missingParms = '%(cmdName)s: Insufficient parameters provided.\n';

  #-------------------------------------------------------------------
  # How many user command line parameters were specified?
  #-------------------------------------------------------------------
  argc = len( sys.argv );                   # Number of arguments
  if ( argc < 3 ) :                         # If too few are present,
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
  badReqdParam = '%(cmdName)s: Missing/invalid required parameter: %(key)s.\n';
  for key in Opts.keys() :
    val = Opts[ key ];
    if ( not val ) or ( not val.strip() ) :
      print badReqdParam % locals();
      Usage();
    cmd = '%s=Opts["%s"]' % ( key, key );
    exec( cmd );

  #-------------------------------------------------------------------
  # Call the AdminTask.createClusterMember() method using the command
  # line parameter values.
  #-------------------------------------------------------------------
  parms = '%(cmdName)s --clusterName %(clusterName)s --nodeName %(nodeName)s --memberName %(memberName)s';
  print parms % locals();
  try :
    Parms = '[-clusterName %s -memberConfig [-memberNode %s -memberName %s]]' % ( clusterName, nodeName, memberName )
    AdminTask.createClusterMember( Parms );
    AdminConfig.save();
    print '%(cmdName)s success. Member %(memberName)s created successfully.' % locals();
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
  shortForm = 'L:m:n:';
  longForm  = 'clusterName=,memberName=,nodeName='.split( ',' );
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
    elif opt in ( '-m', '--memberName' )  : Opts[ 'memberName' ] = val
    elif opt in ( '-n', '--nodeName' )    : Opts[ 'nodeName' ] = val

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
Purpose: wsadmin script used to create an additional member to an existing
         cluster.
  Usage: %(cmdName)s [options]\n
Required switches:
  -L | --clusterName <name> = Name of existing cluster to which the new
                              member is to be added.
  -m | --memberName  <name> = Name of member to be created.
  -n | --nodeName    <name> = Name of node on which member is to be
                              created.
\nNotes:
- Long form option values may be separated/delimited from their associated
  identifier using either a space, or an equal sign ('=').\n
- Short form option values may be sepearated from their associated letter
  using an optional space.\n
- Text containing blanks must be enclosed in double quotes.\n
Examples:
  wsadmin -f %(cmdName)s.py --clusterName=C1 --nodeName N01 --memberName M2
  wsadmin -f %(cmdName)s.py -m Member2 -nNode01 -LC1\n''' % locals();
  sys.exit();

#---------------------------------------------------------------------
# This is the point at which execution begins
#---------------------------------------------------------------------
if ( __name__ == '__main__' ) :
  createClusterMember();
else :
  print 'Error: this script must be executed, not imported.\n';
  Usage();

