#!/usr/bin/env bash

# See https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

COMMAND_LINE_OPTIONS_HELP='
Command line options:
    -d/--data PATH          Path where to find the Owncloud data
    -p/--path PATH   Path where to find the Owncloud application
    -h/--help               Print this help menu

'

print_help() {
    echo $COMMAND_LINE_OPTIONS_HELP
}

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

OPTIONS=d:p:h
LONGOPTIONS=data:,path:,help

# -temporarily store output to be able to check for errors
# -e.g. use “--options” parameter by name to activate quoting/enhanced mode
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -d|--data)
            ocdata="$2"
            shift 2
            ;;
        -p|--path)
            ocpath="$2"
            shift 2
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [ -z "$ocdata" ]; then
    echo "Owncloud Data path required" >&2
    print_help
    exit 1
fi;

if [ -z "$ocpath" ]; then
    echo "Owncloud path required" >&2
    print_help
    exit 1
fi;

htuser='apache'
htgroup='apache'
rootuser='root'

printf "Creating possible missing Directories\n"
mkdir -p $ocdata
mkdir -p $ocpath/updater

printf "chmod Files and Directories\n"
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
find ${ocdata}/ -type f -print0 | xargs -0 chmod 0640
find ${ocdata}/ -type d -print0 | xargs -0 chmod 0750

printf "chown Directories\n"
chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} ${ocdata}/
chown -R ${htuser}:${htgroup} ${ocpath}/updater/

chmod +x ${ocpath}/occ

printf "chmod/chown .htaccess\n"
if [ -f ${ocpath}/.htaccess ]
 then
  chmod 0644 ${ocpath}/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
fi
if [ -f ${ocdata}/.htaccess ]
 then
  chmod 0644 ${ocdata}/.htaccess
  chown ${rootuser}:${htgroup} ${ocdata}/.htaccess
fi
