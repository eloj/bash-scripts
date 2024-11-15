#!/bin/bash
URL=$1
REMOTE=${2:-upstream-ro}
if [ -z "$URL" ]; then
	echo "Usage: $0 <git-url> [remote-name]"
	echo ""
	echo "Please supply git remote to add as $REMOTE, e.g git@github.com:username/reponame.git"
	exit 1
fi
git remote add $REMOTE $URL
if [ $? -eq 0 ]; then
	git remote set-url $REMOTE --push "Do not push directly on upstream"
else
	echo "Error while adding remote, aborting."
fi
