#!/usr/bin/env sh

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

# test_fixed_arg_len tests that the first two parameters don't match and exits
# with $3 if $3 is set, otherwise if the first two parameters don't match and
# $3 isn't set it exits with 1
# @param reqargs [in] required argument count
# @param numargs [in] actual argument count
# @param err [in] the code to exit with if the first two paramaters don't
#   match, defaults to 1
test_fixed_arg_len() {
	local reqargs=$1
	local numargs=$2
	local err=${3:-}
	if [ $reqargs -ne $numargs ]
	then
		echo "wrong number of arguments are present"
		usage
		exit $err
	fi
}
