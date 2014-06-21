#!/usr/bin/env sh

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$*"
readonly NUMARGS="$#"

# Searching parameters
readonly EGREP_OPTIONS=" -THn "
readonly EGREP_PATTERN="strcpy"
readonly FIND_PATTERN=".*\.c"
readonly FIND_OPTIONS=" -type f -a -regex $FIND_PATTERN "

# has_file will print an error if the file doesn't exist and exit with 
# error $2 if $2 is set, or if the file doesn't exist and $2 is not set
# it exits with error 1
# @param file [in] file name to test for existence
# @param err [in] optional error if file doesn't exist, defaults to 1
has_file() {
	local file=$1
	local err=${2:-1}
	if [ ! -f $file ] 
	then
		echo "$file does not exist"
		usage
		exit $err
	fi
}

# has_exec_file will print an error if the file doesn't exist and isn't
# executable  with error $2 if $2 is set, or if the file doesn't exist,
# isn't executable and $2 is not set it exits with error 1
# @param file [in] file name to test for existence and executableness
# @param err [in] optional error if file doesn't exist, defaults to 1
has_exec_file() {
	local file=`which $1`
	local err=${2:-1}
	has_file $file $err
	if [ ! -x $file ] 
	then
		echo "$file is not executable"
		usage
		exit $err
	fi
}

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

