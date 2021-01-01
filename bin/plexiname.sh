#!/bin/bash

# rename files so plex can find them

for f in "$@"; do
	series=$(echo $f | sed -nr  's/^([^-]*)\s.*/\1/p')
	number=$(echo $f | sed -nr  's/^[^-]*\s*-\s*([^-]*)\s.*/\1/p')
	name=$(echo $f | sed -nr  's/^[^-]*\s*-\s*[^-]*\s*-\s*(.*).m4v/\1/p')
	#echo "series: $series, number: $number, name: $name."
	if [ -z "$series" ] || [ -z "$number" ] || [ -z "$name" ]; then
		echo Skipping: $f
		continue
	fi
	number=$(printf "%02d" $number)

	new_filename="$series - $number - $name.m4v"
	
	if [ "$f" == "$new_filename" ]; then
		echo Skipping: $f
		continue
	fi
	echo mv "$f" "$new_filename"

done
