#!/bin/sh

optionHelp=false

GPGNAME=myname

#if (( $# > 1 )); then
#	cat <<- _EOF_
#	格式：$(basename $0) [gpgname]
#	_EOF_
#	exit 1
#elif (( $# == 1 )); then
#	GPGNAME=$1
#fi

argCount=0
while getopts "hg:" Arg; do
	(( argCount++ ))
	case $Arg in
		h)	optionHelp=true
			;;
		g)	GPGNAME=$OPTARG
			;;
		*)	optionHelp=true
			;;
	esac
done
if (( $argCount > 2 )); then
	optionHelp=true
fi

if [ $optionHelp = true ]; then
	cat <<- _EOF_
	格式：$(basename $0) [-h] [-g gpgname]
	选项：
	      -h 显示帮助信息并退出
	      -g 指定gpg name
	_EOF_
	exit 1
fi

item_count=$(apt-key list | grep "^uid.*${GPGNAME}.*" | wc -l)
if (( $item_count > 0 )); then
	for (( i=0; i<${item_count}; i=i+1 )); do
		key_value=`apt-key list | sed -n '/^pub.*/{$!N;/.*\nuid.*'"${GPGNAME}"'/s/^pub.*2048R\/\([0-9a-zA-Z]\{8\}\).*/\1/p}'`
		echo -e "delete keyid ${key_value} ..."
		apt-key del ${key_value}
	done
	apt-get update
else
	echo -e "no keyid for uid \"${GPGNAME}\"!"
fi

exit 0
