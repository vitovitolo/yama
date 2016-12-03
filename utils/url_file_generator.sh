#!/bin/bash
# URL list generator for YAMA
# Requirements: apt-get install pwgen

MYNAME=`basename $0`
FILENAME=`basename ${1}`


if [ -z "${FILENAME}" ] || [ $# -ne 1 ]; then
	echo "usage: ${MYNAME} <output file>"
	echo "<output file>: output filename to write URL list"
	exit 1
fi

while true; do
	FIRST=`pwgen 5 1`
	DOMAIN=`pwgen $((RANDOM%20)) 1`
	PORT=$(($RANDOM%80+8000))
	echo "${FIRST}${DOMAIN},${PORT},/path/to/something/index.html" >> "${FILENAME}"
done

