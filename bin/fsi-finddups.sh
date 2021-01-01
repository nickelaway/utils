#!/bin/bash

## list duplicate files in fsindex output

function readStdIn {
	while read -r line; do
		[[ "$line" == "#*" ]] && continue
		echo $line 
	done
}

input=$(readStdIn)

while read line; do
	echo "## Duplicate: $line"
	echo "$input" | grep $line
done < <(echo "$input" | cut -d ' ' -f 1 | sort | uniq -c | sort -rn | grep -Ev "^\s*1 " | awk '{print $2}')
