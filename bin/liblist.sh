#!/bin/bash

indent=0

printIndent() {
    for ((i = 0; i < indent; i++)); do
        echo -n '  '
    done

}

checkFile() {
	printIndent	
	echo "$1"
	let indent=$indent+1
	while read line; do
		checkFile "$line"
	done < <(ldd "$1" | sed 's/\s*\(.*\)/\1/' | sed 's/.*=> \(.*\)/\1/' | grep -e '^/' | sed 's/\(.*\) (.*)/\1/')
	let indent=$indent-1
}

for f in "$@"; do
	checkFile "$f"
done
