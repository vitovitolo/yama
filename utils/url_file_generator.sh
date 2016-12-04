#!/bin/bash
# URL list generator for YAMA
# Requirements: apt-get install pwgen

MYNAME=`basename $0`


if [ $# -ne 4 ]; then
	echo "usage: ${MYNAME} <output file> <format> <GET op> <random op>"
	echo "<output file>: output filename to write URL list"
	echo "<format>: csv or http"
	echo "<GET op>: GET operation to generate in URL: info, del or add"
	echo "<random op>: random operation in URL: del and adds"
	exit 1
else
	FILENAME=`basename ${1}`
	FORMAT=${2}
	GET_OP=${3}
	RANDOM_OP=${4}
fi

while true; do
	FIRST=`pwgen 5 1`
	DOMAIN=`pwgen $((RANDOM%20)) 1`
	PORT=$(($RANDOM%80+8000))
	if [ "${FORMAT}" == "http" ]; then
		if [ "${RANDOM_OP}" == "yes" ]; then
			OPERATION=$(($RANDOM%3))
			if [ ${OPERATION} == "0" ]; then
				OP="urlinfo"
				OP2="1"
			elif [ ${OPERATION} == "1" ]; then
				OP="urlupdate"
				OP2="add"
			elif [ ${OPERATION} == "2" ]; then
				OP="urlupdate"
				OP2="del"
			fi
		elif [ "${GET_OP}" == "info" ]; then
			OP="urlinfo"
			OP2="1"
		elif [ "${GET_OP}" == "add" ]; then
			OP="urlupdate"
			OP2="add"
		elif [ "${GET_OP}" == "del" ]; then
			OP="urlupdate"
			OP2="del"
		fi
		LINE="http://localhost/${OP}/${OP2}/${FIRST}${DOMAIN}:${PORT}/path/to/something/index.html"
	# Format == csv
	else
		LINE="${FIRST}${DOMAIN},${PORT},/path/to/something/index.html"
	fi
	echo "${LINE}" >> "${FILENAME}"
done

