#!/bin/bash

## Compare sets of fsindex outputs to see which files exist on one disk and not on another.

f1=$1
f2=$2

[ -e "$f1" ] && [ -e "$f2" ] || { 
	echo "Usage: $0 [file1] [file2]"
	exit 1 
}
echo "# Files that exist in $f1 but not $f2..."
while read hash; do
	grep -a "$hash" "$f1"
done < <(join -v 1 <(cat "$f1" | cut -d ' ' -f 1 | sort | uniq) <(cat "$f2" | cut -d ' ' -f 1 | sort | uniq))
