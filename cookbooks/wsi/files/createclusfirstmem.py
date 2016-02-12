#---------------------------------------------------------------------
#       Name: createFirstClusterMember.py
#       Role: Create the first cluster member using a user specified
#             template name.
#     Author: Robert A. (Bob) Gibson [rag]
# History
#   date    ver  who  what 
# --------  ---  ---  ----------
# 10/01/14  0.1  rag  New: created to simplify developerWorks article
#---------------------------------------------------------------------
import sys, getopt;

#---------------------------------------------------------------------
# Name: createFirstClusterMember()
# Role: Placeholder for routine to perform the desired action
#---------------------------------------------------------------------
def createFirstClusterMember( cmdName = 'createFirstClusterMember' ) :
  missingParms = '%(cmdName)s: Insufficient parameters provided.\n';

  #-------------------------------------------------------------------
  # How many user command line parameters were specified?
  #-------------------------------------------------------------------
  argc = len( sys.argv );                   # Number of arguments
  if ( argc < 4 ) :                         # If too few are present,
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
  badReqdParam = '%(cmdName)s: Missing/Invalid required parameter: %(key)s.\n';
  for key in Opts.keys() :
    val = Opts[ key ];
    if ( not val ) or ( not val.strip() ) :
      print badReqdParam % locals();
      Usage();
    cmd = '%s=Opts["%s"]' % ( key, key );
    exec( cmd );

  #-------------------------------------------------------------------
  # Call the AdminTask.createClusterMember() method using the user
  # specified command line parameter values.
  #-------------------------------------------------------------------
  message =  '%(cmdName)s --clusterName %(clusterName)s ';
  message += '--memberName %(memberName)s ';
  message += '--nodeName %(nodeName)s ';
  message += '--templateName %(templateName)s';
  print message % locals();

  try :
    first  = '-firstMember [-templateName %s]' % templateName;
    mbrCfg = '-memberConfig [-memberNode %s -memberName %s]' % ( nodeName, memberName);
    AdminTask.createClusterMember( '[-clusterName %s %s %s]' % ( clusterName, mbrCfg, first ) );
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
  shortForm = 'L:m:n:t:';
  longForm  = 'clusterName=,memberName=,nodeName=,templateName='.split( ',' );
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
    if opt in   ( '-L', '--clusterName'  ) : Opts[ 'clusterName'  ] = val
    elif opt in ( '-m', '--memberName'   ) : Opts[ 'memberName'   ] = val
    elif opt in ( '-n', '--nodeName'     ) : Opts[ 'nodeName'     ] = val
    elif opt in ( '-t', '--templateName' ) : Opts[ 'templateName' ] = val

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
# Name: listAppServerTemplates()
# Role: Return a list of the available Application Server Template names
#---------------------------------------------------------------------
def listAppServerTemplates() :
  result = [];
  for server in AdminConfig.listTemplates( 'Server' ).splitlines() :
    if server.find( 'APPLICATION_SERVER' ) > -1 :
      result.append( server.split( '(', 1 )[ 0 ] );
  return result;

#---------------------------------------------------------------------
# Name: Usage()
# Role: Routine used to provide user with information necessary to
#       use the script.
#---------------------------------------------------------------------
def Usage( cmdName = None ) :
  if not cmdName :
    cmdName = 'createFirstClusterMemberMember'

  print '''Command: %(cmdName)s\n
Purpose: wsadmin script used to create the first cluster member using an
         Application Server template name.\n
  Usage: %(cmdName)s [options]\n
Required switches/options:
  -L | --clusterName  <name> = Name of cluster to be used.
  -m | --memberName   <name> = Name of member to be created.
  -n | --nodeName     <name> = Name of Node on which member will be created.
  -t | --templateName <name> = Name of Application Server Template to be used.
\nNotes:
- Long form option values may be separated/delimited from their associated
  identifier using either a space, or an equal sign ('=').\n
- Short form option values may be sepearated from their associated letter
  using an optional space.\n
- Text containing blanks must be enclosed in double quotes.\n
Examples:
  wsadmin -f %(cmdName)s.py --clusterName=C1 --templateName default
  wsadmin -f %(cmdName)s.py -LC1 -TDeveloperServer''' % locals();
  print '\nAvailable Application Server Template Names:';
  print '  ' + '\n  '.join( listAppServerTemplates() );
  sys.exit();

#---------------------------------------------------------------------
# This is the point at which execution begins
#---------------------------------------------------------------------
if ( __name__ == '__main__' ) :
  createFirstClusterMember();
else :
  print 'Error: this script must be executed, not imported.\n';
  Usage();

