#!/bin/bash
# URL list generator for YAMA
# Requirements: apt-get install pwgen

MYNAME=`basename $0`


if [ $# -ne 3 ]; then
	echo "usage: ${MYNAME} <output file> <format> <opeartion>"
	echo "<output file>: output filename to write URL list"
	echo "<format>: csv or http"
	echo "<operation>: GET operation to generate in URL: info, del, add or random"
	exit 1
else
	FILENAME=`basename ${1}`
	FORMAT=${2}
	GET_OP=${3}
fi

while true; do
	FIRST=`pwgen 5 1`
	DOMAIN=`pwgen $((RANDOM%20)) 1`
	PORTS=(80 443 8080)
	I_PORT=$(($RANDOM%3))
	PATH_RAND=`pwgen $((RANDOM%200+10)) 1`
	QUERY_RAND=`pwgen $((RANDOM%60+10)) 1`
	if [ "${FORMAT}" == "http" ]; then
		if [ "${GET_OP}" == "random" ]; then
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
		LINE="http://localhost/${OP}/${OP2}/${FIRST}${DOMAIN}:${PORTS[${I_PORT}]}/path/to/${PATH_RAND}/${QUERY_RAND}"
	# Format == csv
	else
		LINE="${FIRST}${DOMAIN},${PORT},/path/to/something/index.html"
	fi
	echo "${LINE}" >> "${FILENAME}"
done

