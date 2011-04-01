#!/bin/sh

# Author: Vesselin Petkov <mail@vpetkov.com>
# Version: 2.0
# http://github.com/vpetkov/StaticBlogGenerator
#
# For help on configuration refer to http://github.com/vpetkov/StaticBlogGenerator#readme


# --- Configurable variables -----

# Change the name of the configuration file
CONFIG_FILE_NAME=".blog"
# IMPORTANT: This is just the name of the file. The directory
# where it is stored can be either the $HOME or $PWD.
# The latter is useful for multiple site configurations.

# --------------------------------

while getopts vqgd opts; do
	case "$opts" in
	v)	VERBOSE=1 ;;
	q)	QUIET=1 ;;
	g)	GENERATE=1 ;;
	d)	DEPLOY=1 ;;
	esac
done

if [ -s $PWD/$CONFIG_FILE_NAME ]
then
	CONFIG_FILE_PATH=$PWD/$CONFIG_FILE_NAME
	[ "${QUIET:-0}" -eq 0 ] && echo "Load configuration from $CONFIG_FILE_PATH"

elif [ -s $HOME/$CONFIG_FILE_NAME ]
then
	CONFIG_FILE_PATH=$HOME/$CONFIG_FILE_NAME
	[ "${QUIET:-0}" -eq 0 ] && echo "Load configuration from $CONFIG_FILE_PATH"

else
	[ "${QUIET:-0}" -eq 0 ] && echo "No configuration found"
	exit 1
fi

. $CONFIG_FILE_PATH

markdown()
{
	cat $TEMPLATE_HEADER_FILE > $OUTPUT
	perl $PATH_TO_MARKDOWN $INPUT >> $OUTPUT
	cat $TEMPLATE_FOOTER_FILE >> $OUTPUT
}

if [ "${GENERATE:-0}" -eq 1 ]
then
	[ "${QUIET:-0}" -eq 0 ] && echo "Generate content..."

	TEMPLATE_HEADER_FILE="$TEMPLATE_DIR/$TEMPLATE_HEADER_FILE_NAME.html"
	TEMPLATE_FOOTER_FILE="$TEMPLATE_DIR/$TEMPLATE_FOOTER_FILE_NAME.html"

	if [ -f TEMPLATE_HEADER_FILE ] && [ -f TEMPLATE_FOOTER_FILE ]
	then
		[ "${QUIET:-0}" -eq 0 ] && echo "Template missing"
		exit 2
	fi

	rm -rf $OUTPUT_DIR
	for FILE_PATH in $(find $CONTENT_DIR -iname "*.$CONTENT_FILE_EXTENSION" |
		grep -v "$HOME_PAGE_FILE_NAME.$CONTENT_FILE_EXTENSION"); do

		local INPUT=$FILE_PATH

		FILE_PATH=${FILE_PATH%.markdown}
		FILE_PATH=${FILE_PATH#$CONTENT_DIR/}
		FILE_PATH=$OUTPUT_DIR/$FILE_PATH
		mkdir -p $FILE_PATH
		[ "${VERBOSE:-0}" -ge 1 ] && echo $FILE_PATH

		local OUTPUT=$FILE_PATH/index.html
		markdown

		[ "${VERBOSE:-0}" -ge 1 ] && echo $OUTPUT
	done

	[ "${QUIET:-0}" -eq 0 ] && echo "Generate home page..."

	FILE_PATH=$CONTENT_DIR/$HOME_PAGE_FILE_NAME.$CONTENT_FILE_EXTENSION
	if [ -d $HOME_PAGE_TEMPLATE_DIR ]
	then
		if [ -f "$HOME_PAGE_TEMPLATE_DIR/$TEMPLATE_HEADER_FILE_NAME.html" ]
		then 
			TEMPLATE_HEADER_FILE="$HOME_PAGE_TEMPLATE_DIR/$TEMPLATE_HEADER_FILE_NAME.html"
		fi

		if [ -f "$HOME_PAGE_TEMPLATE_DIR/$TEMPLATE_FOOTER_FILE_NAME.html" ]
		then 
			TEMPLATE_FOOTER_FILE="$HOME_PAGE_TEMPLATE_DIR/$TEMPLATE_FOOTER_FILE_NAME.html"
		fi
	fi

	if [ -f $FILE_PATH ]
	then
		local INPUT=$FILE_PATH
		local OUTPUT=$OUTPUT_DIR/index.html
		markdown
		[ "${VERBOSE:-0}" -ge 1 ] && echo $OUTPUT
	fi
fi

if [ "${DEPLOY:-0}" -eq 1 ]
then
	[ "${QUIET:-0}" -eq 0 ] && echo "Deploy..."

	if [ -z $DEPLOY_USER ] && [ -z $DEPLOY_HOST ] && [ -d $OUTPUT_DIR ] && [ -d $DEPLOY_DIR ]
	then
		cp -rf $([ "${VERBOSE:-0}" -ge 1 ] && echo "-v") $OUTPUT_DIR/* $DEPLOY_DIR/

	elif [ ! -z $DEPLOY_USER ] && [ ! -z $DEPLOY_HOST ] && [ -d $OUTPUT_DIR ] && [ -d $DEPLOY_DIR ]
	then
		rsync -r $([ "${VERBOSE:-0}" -ge 1 ] && echo "-v") $OUTPUT_DIR/* $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_DIR/
	fi
fi

[ "${QUIET:-0}" -eq 0 ] && echo "Done."
exit 0
