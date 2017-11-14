#!/bin/sh

SELFPATH=$(cd "$(dirname "$0")"; pwd | sed 's;\(^/.*[^/]$\);\1/;')

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

rm -f ${PATHNAME}dists/xenial/Release
rm -f ${PATHNAME}dists/xenial/InRelease
rm -f ${PATHNAME}dists/xenial/Release.gpg
apt-ftparchive -c ${SELFPATH}apt-release.cnf  release ${PATHNAME}dists/xenial > ${PATHNAME}.Release
mv ${PATHNAME}.Release ${PATHNAME}dists/xenial/Release
gpg --clearsign -o ${PATHNAME}dists/xenial/InRelease ${PATHNAME}dists/xenial/Release
gpg -o ${PATHNAME}dists/xenial/Release.gpg -abs ${PATHNAME}dists/xenial/Release

exit 0
