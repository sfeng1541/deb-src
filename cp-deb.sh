#!/bin/sh

optionHelp=false

PATHNAME="/var/debian-dev/"

argCount=0
while getopts "hp:" Arg; do
	(( argCount++ ))
	case $Arg in
		h)	optionHelp=true
			;;
		p)	PATHNAME=$OPTARG
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
	格式：$(basename $0) [-h] [-p pathname]
	选项：
	      -h 显示帮助信息并退出
	      -p 指定本地源路径
	_EOF_
	exit 1
fi

cp -vrp /var/cache/apt/archives/*.deb "${PATHNAME}pool/main/"

exit 0
