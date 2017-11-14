#!/bin/sh

optionHelp=false

GPGNAME=myname
PATHNAME="/var/debian-dev/"

argCount=0
while getopts "hg:p:" Arg; do
	(( argCount++ ))
	case $Arg in
		h)	optionHelp=true
			;;
		g)	GPGNAME=$OPTARG
			;;
		p)	PATHNAME=$OPTARG
			;;
		*)	optionHelp=true
			;;
	esac
done
if (( $argCount > 3 )); then
	optionHelp=true
fi

if [ $optionHelp = true ]; then
	cat <<- _EOF_
	格式：$(basename $0) [-h] [-g gpgname] [-p pathname]
	选项：
	      -h 显示帮助信息并退出
	      -g 指定gpg name
	      -p 指定本地源路径
	_EOF_
	exit 1
fi

echo "generate keyFile..."

item_count=$(gpg --list-keys | grep "^uid.*${GPGNAME}.*" | wc -l)
if (( $item_count == 0 )); then
	echo "key ${GPGNAME} not found."
	exit 0
fi

key_value=`gpg --list-keys | sed -n '/^pub.*/{$!N;/.*\nuid.*'"${GPGNAME}"'/s/^pub.*2048R\/\([0-9a-zA-Z]\{8\}\).*/\1/p}'`
echo "keyid for keyFile: ${key_value}"
gpg --export ${key_value} > "${PATHNAME}keyFile"

echo "done."

exit 0
