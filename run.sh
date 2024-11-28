#!/bin/sh
gcc -no-pie -z noexecstack -m32 $1 -o $2
echo "a mers" 
if [ "$3" = "y" ]; then
	./$2
fi

