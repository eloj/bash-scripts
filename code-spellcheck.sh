#!/bin/bash
#
# Detect common spelling errors in git repos.
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
	"Alliased:Aliased"
	"Comand:Command"
	"Probalby:Probably"
	"acutally:actually"
	"addesses:addresses"
	"beggining:beginning"
	"begining:beginning"
	"bewteen:between"
	"capabilites:capabilities"
	"cheching:checking"
	"chek:check"
	"coalesed:coalesced"
	"commited:committed"
	"confict:conflict"
	"configue:configure"
	"containig:containing"
	"continguous:contiguous"
	"decription:description"
	"desriptions:descriptions"
	"differenciate:differentiate"
	"divisable:divisible"
	"droping:dropping"
	"exisitng:existing"
	"exlusive:exclusive"
	"facor:factor"
	"improvments:improvements"
	"indepdenent:independent"
	"intermidiate:intermediate"
	"inteval:interval"
	"libary:library"
	"minimun:minimum"
	"modifed:modified"
	"neccessary:necessary"
	"noticable:noticeable"
	"notificatons:notifications"
	"occured:occurred"
	"occuring:occurring"
	"otherwize:otherwise"
	"ouput:output"
	"paramter:parameter"
	"permissons:permissions"
	"portait:portrait"
	"preceeding:preceding"
	"prefered:preferred"
	"publically:publicly"
	"recieve:receive"
	"recieving:receiving"
	"refernece:reference"
	"resetted:reset"
	"sorrounding:surrounding"
	"specififed:specified"
	"spliting:splitting"
	"strutures:structures"
	"threshhold:threshold"
	"uless:unless"
	"unavaliable:unavailable"
	"unkown:unknown"
	"unsinged:unsigned"
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
