#!/bin/bash

usage () {
	echo Usage: $0 [properties file]... && exit 1
}

[ -z "$*" ] && usage

file=""
count=0
while getopts ":f:c:" o; do
    case "${o}" in
        f)
	    file=$OPTARG
            ;;
        c)
	    count=$OPTARG
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

[ ! -e "$file" ] && echo "File not found: $file" && exit 1

max=$(wc -l $file | cut -d ' ' -f 1)
for i in $(seq 1 $count); do
	line_number=$(( ( RANDOM % $max )  + 1 ))
	line=$(head -$line_number $file | tail -1)
	echo -n "$line "
done
echo
