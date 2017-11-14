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

/usr/bin/expect <<- _EOF_
set timeout -1
spawn gpg --gen-key
expect {
	"您的选择？" { send "4\n"; exp_continue }
	"Your selection" { send "4\n"; exp_continue }
	"您想要用多大的密钥尺寸？" { send "2048\n"; exp_continue }
	"What keysize do you want" { send "2048\n"; exp_continue }
	"密钥的有效期限是？" { send "10y\n"; exp_continue }
	"Key is valid for" { send "10y\n"; exp_continue }
	"以上正确吗？" { send "y\n"; exp_continue }
	"Is this correct" { send "y\n"; exp_continue }
	"真实姓名：" { send "$GPGNAME\n"; exp_continue }
	"Real name:" { send "$GPGNAME\n"; exp_continue }
	"电子邮件地址：" { send "$GPGNAME@xxx.com\n"; exp_continue }
	"Email address:" { send "$GPGNAME@xxx.com\n"; exp_continue }
	"注释：" { send "comm\n"; exp_continue }
	"Comment:" { send "comm\n"; exp_continue }
	"或确定(O)/退出(Q)？" { send "O\n"; exp_continue }
	"or (O)kay/(Q)uit?" { send "O\n"; exp_continue }
	"请输入密码" { send "$GPGNAME\n"; exp_continue }
	"Enter passphrase:" { send "$GPGNAME\n"; exp_continue }
	"请再输入一次密码" { send "$GPGNAME\n"; exp_continue }
	"Repeat passphrase:" { send "$GPGNAME\n"; exp_continue }
	eof { send_user "auto eof\n" }
}
#spawn ./genkeyFile.sh
#expect eof
_EOF_

${SELFPATH}genkeyFile.sh -g ${GPGNAME} -p ${PATHNAME}

exit 0
