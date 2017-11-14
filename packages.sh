#!/bin/sh

ARCH="amd64"
COMP="contrib main non-free"

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

for arch in $ARCH
do
        for cc in $COMP 
        do
                dpkg-scanpackages -a $arch ${PATHNAME}pool/$cc > ${PATHNAME}dists/xenial/$cc/binary-$arch/Packages
                gzip -9c ${PATHNAME}dists/xenial/$cc/binary-$arch/Packages > ${PATHNAME}dists/xenial/$cc/binary-$arch/Packages.gz
        done
done

for cc in $COMP
do
        dpkg-scansources ${PATHNAME}pool/$cc > ${PATHNAME}dists/xenial/$cc/source/Sources
        gzip -9c ${PATHNAME}dists/xenial/$cc/source/Sources > ${PATHNAME}dists/xenial/$cc/source/Sources.gz
done

exit 0
