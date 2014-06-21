#!/usr/bin/env sh

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$*"
readonly NUMARGS="$#"

. $PROGDIR/../util/util.sh

# Searching parameters
readonly EGREP_OPTIONS=" -THn "
readonly EGREP_PATTERN="strcpy"
readonly FIND_PATTERN=".*\.c"
readonly FIND_OPTIONS=" -type f -a -regex $FIND_PATTERN "

# usage displays the usage message
usage() {
	cat <<- EOF
	usage: $PROGNAME path_to_file_or_dir

	$PROGNAME will search through a file, or recursively through a directory
	for files that contain strcpy, and report the filename and line number.
	EOF
}

if [ ! 1 -eq $NUMARGS ]
then
	echo "wrong number of arguments are present"
	usage && exit 2
fi

readonly ARGPATH=$1

has_exec_file egrep 4
has_exec_file xargs 5
has_exec_file find 6

if [ -d $ARGPATH ]
then
	# The argument is a directory
	readonly ARGDIR=$ARGPATH
	find $ARGPATH $FIND_OPTIONS | xargs egrep $EGREP_OPTIONS "$EGREP_PATTERN" 
elif [ -f $ARGPATH ]
then
	# The argument is a file
	readonly ARGFILE=$ARGPATH
	egrep $EGREP_OPTIONS "$EGREP_PATTERN" $ARGFILE
else
	echo $ARGPATH is not a file or directory.
	usage
	exit 7
fi
