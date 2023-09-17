#!/bin/bash

## Compare sets of fsindex outputs to see which files exist on one disk 

f1=$1
f2=$2

[ -e "$f1" ] && [ -e "$f2" ] || { 
	echo "Usage: $0 [file1] [file2]"
	exit 1 
}
echo "# Files that exist in $f1 and also in $f2..."
while read hash; do
	grep -a "$hash" "$f1"
done < <(join  <(cat "$f1" | cut -d ' ' -f 1 | sort | uniq) <(cat "$f2" | cut -d ' ' -f 1 | sort | uniq))
