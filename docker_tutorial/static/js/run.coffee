
###
  Function to parse docker 'run' specifically, and return the expected output
###

@docker_run = (ARGS) ->

  SWITCHES = [
    ['-P', '--publish-all', '=false: Publish all exposed ports to the host interfaces'],
    ['-a', '--attach []', 'Attach to stdin, stdout or stderr.'],
    ['--cidfile ""', 'Write the container ID to the file']
  ]

  parser = new optparse.OptionParser(SWITCHES)
  parser.banner =
  """
  Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

  Run a command in a new container
  """

  c = {}

  # prep the parser
  parser.on(2, (value) ->
    ### Get the image name ###
    parserterm.echo "parser.on(2, (#{value}) ->"
    c.image = value
  )

  parser.on(3, (value) ->
    ### Get all remaining arguments and stow them in c.cmd ###
    i = 0
    for element in ARGS
      if element is value
        break
      i++

    c.cmd = ARGS.slice(i,)
  )

  # parse it
  parser.parse(ARGS)


  if not c.image
    return parser.toString()

  if c.image is 'ubuntu' and not c.cmd
    return run_no_command

  if c.image is 'ubuntu' and c.cmd.containsAllOfThese(['apt-get', 'install'])
    ### parse apt-get install and return the value ###
    program = ''
    dashyeserror = true

    # Create parser and parse apt commands
    aptparser = new optparse.OptionParser([['-y', '--assume-yes', 'assume yes']])
    aptparser.on('assume-yes', () -> dashyeserror = false )
    aptparser.on(2, (value) ->  program = value )
    aptparser.parse(c.cmd)

    if dashyeserror
      return run_apt_get_install_without_y()
    if program is 'fortunes'
      return run_apt_get_install_fortunes()
    else
      return run_apt_get_install_unknown_package(program)

  if c.image is 'ubuntu' and c.cmd.containsAllOfThese(['apt-get'])
    console.log ("all good, matched docker c.cmd: #{c.cmd}")
    return run_apt_get
  else
    return run_image_wrong_command(c.cmd[0])






###
  Collection of Mock RUN results
###

run_apt_get = () ->
  """
  apt 0.8.16~exp12ubuntu10 for amd64 compiled on Apr 20 2012 10:19:39
  Usage: apt-get [options] command
         apt-get [options] install|remove pkg1 [pkg2 ...]
         apt-get [options] source pkg1 [pkg2 ...]

  apt-get is a simple command line interface for downloading and
  installing packages. The most frequently used commands are update
  and install.

  Commands:
     update - Retrieve new lists of packages
     upgrade - Perform an upgrade
     install - Install new packages (pkg is libc6 not libc6.deb)
     remove - Remove packages
     autoremove - Remove automatically all unused packages
     purge - Remove packages and config files
     source - Download source archives
     build-dep - Configure build-dependencies for source packages
     dist-upgrade - Distribution upgrade, see apt-get(8)
     dselect-upgrade - Follow dselect selections
     clean - Erase downloaded archive files
     autoclean - Erase old downloaded archive files
     check - Verify that there are no broken dependencies
     changelog - Download and display the changelog for the given package
     download - Download the binary package into the current directory

  Options:
    -h  This help text.
    -q  Loggable output - no progress indicator
    -qq No output except for errors
    -d  Download only - do NOT install or unpack archives
    -s  No-act. Perform ordering simulation
    -y  Assume Yes to all queries and do not prompt
    -f  Attempt to correct a system with broken dependencies in place
    -m  Attempt to continue if archives are unlocatable
    -u  Show a list of upgraded packages as well
    -b  Build the source package after fetching it
    -V  Show verbose version numbers
    -c=? Read this configuration file
    -o=? Set an arbitrary configuration option, eg -o dir::cache=/tmp
  See the apt-get(8), sources.list(5) and apt.conf(5) manual
  pages for more information and options.
                         This APT has Super Cow Powers.

  """

run_apt_get_install_iputils_ping = \
  """
    Reading package lists...
    Building dependency tree...
    The following NEW packages will be installed:
      iputils-ping
    0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 56.1 kB of archives.
    After this operation, 143 kB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu/ precise/main iputils-ping amd64 3:20101006-1ubuntu1 [56.1 kB]
    debconf: delaying package configuration, since apt-utils is not installed
    Fetched 56.1 kB in 1s (50.3 kB/s)
    Selecting previously unselected package iputils-ping.
    (Reading database ... 7545 files and directories currently installed.)
    Unpacking iputils-ping (from .../iputils-ping_3%3a20101006-1ubuntu1_amd64.deb) ...
    Setting up iputils-ping (3:20101006-1ubuntu1) ...
  """

run_apt_get_install_unknown_package = (keyword) ->
  """
    Reading package lists...
    Building dependency tree...
    E: Unable to locate package #{keyword}
  """

run_apt_get_install_fortunes = () ->
  """
  Reading package lists...
  Building dependency tree...
  The following extra packages will be installed:
    fortune-mod fortunes-min librecode0
  Suggested packages:
    x11-utils bsdmainutils
  The following NEW packages will be installed:
    fortune-mod fortunes fortunes-min librecode0
  0 upgraded, 4 newly installed, 0 to remove and 63 not upgraded.
  Need to get 2009 kB of archives.
  After this operation, 5098 kB of additional disk space will be used.
  Get:1 http://archive.ubuntu.com/ubuntu/ precise/main librecode0 amd64 3.6-18 [770 kB]
  Get:2 http://archive.ubuntu.com/ubuntu/ precise/main fortune-mod amd64 1:1.99.1-4 [50.4 kB]
  Get:3 http://archive.ubuntu.com/ubuntu/ precise/main fortunes-min all 1:1.99.1-4 [72.4 kB]
  Get:4 http://archive.ubuntu.com/ubuntu/ precise/universe fortunes all 1:1.99.1-4 [1116 kB]
  debconf: unable to initialize frontend: Dialog
  debconf: (TERM is not set, so the dialog frontend is not usable.)
  debconf: falling back to frontend: Readline
  debconf: unable to initialize frontend: Readline
  debconf: (Can't locate Term/ReadLine.pm in @INC (@INC contains: /etc/perl /usr/local/lib/perl/5.14.2 /usr/local/share/perl/5.14.2 /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.14 /usr/share/perl/5.14 /usr/local/lib/site_perl .) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7, <> line 4.)
  debconf: falling back to frontend: Teletype
  dpkg-preconfigure: unable to re-open stdin:
  Fetched 2009 kB in 2s (693 kB/s)
  Selecting previously unselected package librecode0.
  (Reading database ... 9737 files and directories currently installed.)
  Unpacking librecode0 (from .../librecode0_3.6-18_amd64.deb) ...
  Selecting previously unselected package fortune-mod.
  Unpacking fortune-mod (from .../fortune-mod_1%3a1.99.1-4_amd64.deb) ...
  Selecting previously unselected package fortunes-min.
  Unpacking fortunes-min (from .../fortunes-min_1%3a1.99.1-4_all.deb) ...
  Selecting previously unselected package fortunes.
  Unpacking fortunes (from .../fortunes_1%3a1.99.1-4_all.deb) ...
  Setting up librecode0 (3.6-18) ...
  Setting up fortune-mod (1:1.99.1-4) ...
  Setting up fortunes-min (1:1.99.1-4) ...
  Setting up fortunes (1:1.99.1-4) ...
  Processing triggers for libc-bin ...
  ldconfig deferred processing now taking place
  """

run_apt_get_install_without_y = () ->
  """
  Reading package lists...
  Building dependency tree...
  The following extra packages will be installed:
    fortune-mod fortunes-min librecode0
  Suggested packages:
    x11-utils bsdmainutils
  The following NEW packages will be installed:
    fortune-mod fortunes fortunes-min librecode0
  0 upgraded, 4 newly installed, 0 to remove and 63 not upgraded.
  Need to get 2009 kB of archives.
  After this operation, 5098 kB of additional disk space will be used.
  Do you want to continue [Y/n]? Abort.
  """


run_flag_defined_not_defined = (keyword) ->
  """
  #{utils.timestamp()} flag provided but not defined: #{keyword}
  """

run_no_command = () ->
  """
  #{utils.timestamp()} Error: No command specified
  """

run_learn_tutorial_echo_hello_world = (commands) ->
  string = ""
  for command in commands[1..]
    command = command.replace('"','');
    string += ("#{command} ")
  return string


run_image_wrong_command = (keyword) ->
  """
  #{utils.timestamp()} exec: "#{keyword}": executable file not found in $PATH
  """

run_notfound = (keyword) ->
  """
  Pulling repository #{keyword} from https://index.docker.io/v1
  #{utils.timestamp()} Error: No such image: #{keyword}
  """

run_ping_not_google = (keyword) ->
  """
  ping: unknown host #{keyword}
  """

run_ping_www_google_com = \
  """
  PING www.google.com (74.125.239.129) 56(84) bytes of data.
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=1 ttl=55 time=2.23 ms
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=2 ttl=55 time=2.30 ms
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=3 ttl=55 time=2.27 ms
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=4 ttl=55 time=2.30 ms
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=5 ttl=55 time=2.25 ms
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=6 ttl=55 time=2.29 ms
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=7 ttl=55 time=2.23 ms
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=8 ttl=55 time=2.30 ms
  64 bytes from nuq05s02-in-f20.1e100.net (74.125.239.148): icmp_req=9 ttl=55 time=2.35 ms
  -> This would normally just keep going. However, this emulator does not support Ctrl-C, so we quit here.
  """