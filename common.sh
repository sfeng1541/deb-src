#!/bin/sh

# argu: file, key, sharp, bak
function sharpItem() {
	sed_i="-i.bak"
	if [ ${4} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?${2}=.*" ${1} | wc -l)
	if (( $item_count > 0 )); then
		if [ ${3} = true ]; then
			sed ${sed_i} '0,/^#\?'"${2}"'=.*/ s/^#\?\('"${2}"'=.*\)/#\1/' ${1}
		else
			sed ${sed_i} '0,/^#\?'"${2}"'=.*/ s/^#\?\('"${2}"'=.*\)/\1/' ${1}
		fi
	fi
}
function sharpItemBak() {
	sharpItem "${1}" "${2}" ${3} true
}
function sharpItemNoBak() {
	sharpItem "${1}" "${2}" ${3} false
}

# argu: file, key, value, bak
function addItemBlank() {
	sed_i="-i.bak"
	if [ ${4} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?${2}=.*" ${1} | wc -l)
	if (( $item_count == 0 )); then
		sed ${sed_i} '0,/^$/ s/^$/'"${2}=${3}"'/' ${1}
	else
		sed ${sed_i} '0,/^#\?'"${2}"'=.*/ s/^#\?\('"${2}"'\)=.*/\1='"${3}"'/' ${1}
	fi
}
function addItemBlankBak() {
	addItemBlank "${1}" "${2}" "${3}" true
}
function addItemBlankNoBak() {
	addItemBlank "${1}" "${2}" "${3}" false
}

# argu: file, after, key, value, bak
function addItemAfter() {
	sed_i="-i.bak"
	if [ ${5} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?${3}=.*" ${1} | wc -l)
	if (( $item_count == 0 )); then
		sed ${sed_i} '/^ *'"${2}"'=.*/a\'"${3}=${4}" ${1}
	else
		sed ${sed_i} '0,/^#\?'"${3}"'=.*/ s/^#\?\('"${3}"'\)=.*/\1='"${4}"'/' ${1}
	fi
}
function addItemAfterBak() {
	addItemAfter "${1}" "${2}" "${3}" "${4}" true
}
function addItemAfterNoBak() {
	addItemAfter "${1}" "${2}" "${3}" "${4}" false
}

# argu: file, key, value, bak
function addItemTail() {
	sed_i="-i.bak"
	if [ ${4} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?${2}=.*" ${1} | wc -l)
	if (( $item_count == 0 )); then
		sed ${sed_i} '$a\'"${2}=${3}" ${1}
	else
		sed ${sed_i} '0,/^#\?'"${2}"'=.*/ s/^#\?\('"${2}"'\)=.*/\1='"${3}"'/' ${1}
	fi
}
function addItemTailBak() {
	addItemTail "${1}" "${2}" "${3}" true
}
function addItemTailNoBak() {
	addItemTail "${1}" "${2}" "${3}" false
}

# argu: file, key, bak
function delItem() {
	sed_i="-i.bak"
	if [ ${3} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?${2}=.*" ${1} | wc -l)
	if (( $item_count > 0 )); then
		sed ${sed_i} '/^#\?'"${2}"'=.*/d' ${1}
	fi
}
function delItemBak() {
	delItem "${1}" "${2}" true
}
function delItemNoBak() {
	delItem "${1}" "${2}" false
}


# argu: file, line, sharp, bak
function sharpLine() {
	sed_i="-i.bak"
	if [ ${4} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?.*${2}.*" ${1} | wc -l)
	if (( $item_count > 0 )); then
		if [ ${3} = true ]; then
			sed ${sed_i} '0,/^#\?.*'"${2}"'.*/ s/^#\?\(.*'"${2}"'.*\)/#\1/' ${1}
		else
			sed ${sed_i} '0,/^#\?.*'"${2}"'.*/ s/^#\?\(.*'"${2}"'.*\)/\1/' ${1}
		fi
	fi
}
function sharpLineBak() {
	sharpLine "${1}" "${2}" ${3} true
}
function sharpLineNoBak() {
	sharpLine "${1}" "${2}" ${3} false
}

# argu: file, line, bak
function addLineBlank() {
	sed_i="-i.bak"
	if [ ${3} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?.*${2}.*" ${1} | wc -l)
	if (( $item_count == 0 )); then
		sed ${sed_i} '0,/^$/ s/^$/'"${2}"'/' ${1}
	fi
}
function addLineBlankBak() {
	addLineBlank "${1}" "${2}" true
}
function addLineBlankNoBak() {
	addLineBlank "${1}" "${2}" false
}

# argu: file, after, line, bak
function addLineAfter() {
	sed_i="-i.bak"
	if [ ${4} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?.*${3}.*" ${1} | wc -l)
	if (( $item_count == 0 )); then
		sed ${sed_i} '/^ *'"${2}"'.*/a\'"${3}" ${1}
	fi
}
function addLineAfterBak() {
	addLineAfter "${1}" "${2}" "${3}" true
}
function addLineAfterNoBak() {
	addLineAfter "${1}" "${2}" "${3}" false
}

# argu: file, line, bak
function addLineTail() {
	sed_i="-i.bak"
	if [ ${3} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?.*${2}.*" ${1} | wc -l)
	if (( $item_count == 0 )); then
		sed ${sed_i} '$a\'"${2}" ${1}
	fi
}
function addLineTailBak() {
	addLineTail "${1}" "${2}" true
}
function addLineTailNoBak() {
	addLineTail "${1}" "${2}" false
}

# argu: file, line, bak
function delLine() {
	sed_i="-i.bak"
	if [ ${3} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?.*${2}.*" ${1} | wc -l)
	if (( $item_count > 0 )); then
		sed ${sed_i} '/^#\?.*'"${2}"'.*/d' ${1}
	fi
}
function delLineBak() {
	delLine "${1}" "${2}" true
}
function delLineNoBak() {
	delLine "${1}" "${2}" false
}

# argu: file, line, newline, bak
function changeLine() {
	sed_i="-i.bak"
	if [ ${4} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?.*${2}.*" ${1} | wc -l)
	if (( $item_count > 0 )); then
		sed ${sed_i} '0,/^#\?.*'"${2}"'.*/ s/^#\?.*'"${2}"'.*/'"${3}"'/' ${1}
	fi
}
function changeLineBak() {
	changeLine "${1}" "${2}" "${3}" true
}
function changeLineNoBak() {
	changeLine "${1}" "${2}" "${3}" false
}

# argu: file, line, front, bak
function frontLine() {
	sed_i="-i.bak"
	if [ ${4} = false ]; then
		sed_i="-i"
	fi
	item_count=$(grep "^#\?${2}.*" ${1} | wc -l)
	if (( $item_count > 0 )); then
		sed ${sed_i} '0,/^#\?'"${2}"'.*/ s/^#\?\('"${2}"'.*\)/'"${3}"'\1/' ${1}
	fi
}
function frontLineBak() {
	frontLine "${1}" "${2}" "${3}" true
}
function frontLineNoBak() {
	frontLine "${1}" "${2}" "${3}" false
}

