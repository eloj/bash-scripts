#!/bin/bash
#
# Detect common spelling errors in code bases.
#
# NOTE: Doesn't match case on output; make sure you diff and correct as needed.
#
# See also: 'codespell'
#
DIR=${1:-src}

if [[ ! -d "${DIR}" ]]; then
	echo "Couldn't find target directory: ${DIR}"
	exit 1
fi

# Collection of real-life corrections.
# Move to separate file?
declare -a subst=(
	"addesses:addresses"
	"beggining:beginning"
	"begining:beginning"
	"cheching:checking"
	"chek:check"
	"commited:committed"
	"confict:conflict"
	"decription:description"
	"desriptions:descriptions"
	"differenciate:differentiate"
	"droping:dropping"
	"exisitng:existing"
	"exlusive:exclusive"
	"facor:factor"
	"improvments:improvements"
	"indepdenent:independent"
	"intermidiate:intermediate"
	"inteval:interval"
	"libary:library"
	"modifed:modified"
	"neccessary:necessary"
	"noticable:noticeable"
	"occured:occurred"
	"otherwize:otherwise"
	"permissons:permissions"
	"publically:publicly"
	"recieve:receive"
	"recieving:receiving"
	"refernece:reference"
	"spliting:splitting"
	"unavaliable:unavailable"
	"unkown:unknown"
	"untill:until"
	"vlaue:value"
	"wether:whether"
)

for sub in "${subst[@]}"; do
	FROM=${sub%%:*}
	TO=${sub#*:}
	echo "Checking for ${FROM}"
	mapfile -t CANDIDATES < <(git grep --name-only --ignore-case --word-regexp "${FROM}")
	for file in "${CANDIDATES[@]}"; do
		echo "Applying ${FROM} -> ${TO} to file ${file}"
		sed -i "s,${FROM},${TO},gi" "${file}"
	done
done
