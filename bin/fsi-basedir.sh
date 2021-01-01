#!/bin/bash

## extract directory component from fsindex output
#| awk '{$1=""; print $0}'
while read -r line; do
	[[ "$line" == "#*" ]] && continue
	dirname "$(echo $line | awk '{$1=""; print $0}')"
done
