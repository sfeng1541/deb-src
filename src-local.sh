#!/bin/sh

SELFPATH=$(cd "$(dirname "$0")"; pwd | sed 's;\(^/.*[^/]$\);\1/;')

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

${SELFPATH}apt-key-del.sh -g ${GPGNAME}
${SELFPATH}genkey-auto.sh -g ${GPGNAME} -p ${PATHNAME}
${SELFPATH}release-auto.sh -g ${GPGNAME} -p ${PATHNAME}
apt-key add ${PATHNAME}keyFile
apt-get update

exit 0
