#!/bin/sh

SELFPATH=$(cd "$(dirname "$0")"; pwd | sed 's;\(^/.*[^/]$\);\1/;')

. ${SELFPATH}common.sh

optionHelp=false
optionVerbose=false
optionConfig=false
optionDel=false

Verbose=""

DEBUG=false
#DEBUG=true

if [ $DEBUG = false ]; then
	SOURCES="/etc/apt/sources.list"
else
	SOURCES="./sources.list"
fi

GPGNAME=myname
PATHNAME="/var/debian-dev/"

argCount=0
while getopts "hvcdg:p:" Arg; do
	(( argCount++ ))
	case $Arg in
		h)	optionHelp=true
			;;
		v)	optionVerbose=true
			;;
		c)	optionConfig=true
			;;
		d)	optionDel=true
			;;
		g)	GPGNAME=$OPTARG
			;;
		p)	PATHNAME=$OPTARG
			;;
		*)	optionHelp=true
			;;
	esac
done
if (( $argCount < 1 || $argCount > 5 )); then
	optionHelp=true
fi

paraMutex=0
if [ $optionConfig = true ]; then
	(( paraMutex++ ))
fi
if [ $optionDel = true ]; then
	(( paraMutex++ ))
fi
if (( $paraMutex > 1 )); then
	optionHelp=true
fi

if [ $optionHelp = true ]; then
	cat <<- _EOF_
	格式：$(basename $0) [-h] [-v] [-c|d] [-g gpgname] [-p pathname]
	选项：
	      -h 显示帮助信息并退出
	      -v 显示执行过程
	      -c 配置apt源
	      -d 恢复原apt源配置
	      -g 指定gpg name
	      -p 指定本地源路径
	_EOF_
	exit 1
fi

if [ $optionVerbose = true ]; then
	Verbose="-v"
fi

if [ $optionConfig = true ]; then
	if [ ! -e "${SOURCES}" ]; then
		echo -e "${SOURCES}文件不存在，无法修改！"
		exit 2
	fi

	sources_sed_i=true
	if [ -e "${SOURCES}.bak" ]; then
		read -n1 -p "${SOURCES}.bak已存在，是否覆盖[y/N]？ " yn
		case $yn in
			y|Y) ;;
			n|N) sources_sed_i=false ;;
			*) sources_sed_i=false ;;
		esac
		echo -e ""
	fi

	echo -e "修改${SOURCES} ..."
#	addLineTail "${SOURCES}" "deb file:\/\/\/var\/debian-dev\/ xenial-dev contrib main" ${sources_sed_i}
#	addLineTailNoBak "${SOURCES}" "deb-src file:\/\/\/var\/debian-dev\/ xenial-dev contrib main"
	paradeb="deb file://${PATHNAME} xenial-dev contrib main"
	paradebsrc="deb-src file://${PATHNAME} xenial-dev contrib main"
	addLineTail "${SOURCES}" "${paradeb}" ${sources_sed_i}
	addLineTailNoBak "${SOURCES}" "${paradebsrc}"
	echo -e "修改完成."

	if [ $DEBUG = false ]; then
		apt-key add ${PATHNAME}keyFile
		apt-get update
	fi
fi

if [ $optionDel = true ]; then
	if [ -e "${SOURCES}.bak" ]; then
		rm $Verbose "$SOURCES"
		cp $Verbose "${SOURCES}.bak" "${SOURCES}"
		echo -e "${SOURCES}文件已恢复."
	else
		echo -e "${SOURCES}.bak文件不存在，无法恢复！"
	fi

	if [ $DEBUG = false ]; then
		${SELFPATH}apt-key-del.sh -g ${GPGNAME}
	fi
fi

exit 0
