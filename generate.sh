#!/bin/sh

# Author: Vesselin Petkov <mail@vpetkov.com>
# Version: 0.1
# https://github.com/vpetkov/StaticBlogGenerator
#
# --- Configurable variables -----
#
# Skip the trailing forward slash (i.e. "/") when
# specifying paths.
#
# Both absolute and relative paths are OK.

local OUTPUT_DIR="./html"

local CONTENT_DIR="./content"

local CONTENT_FILE_EXTENSION="markdown"

local HOME_PAGE_FILE_NAME="home"

# --- Variables not recomended for reconfiguration -----

local PATH_TO_MARKDOWN="./markdown/Markdown.pl"

# Template files must have .html extensions
# and must contain valid HTML

local TEMPLATE_DIR="./templates"

# By default the templates for the home page are stored
# in sub-dir of the main template dir named after
# the home page content file.
# If no suitable template files are found for the home
# page the default ones will be used.

local HOME_PAGE_TEMPLATE_DIR=$HOME_PAGE_FILE_NAME

# Note that the header and footer templates for the home
# page template should have the same names.

local TEMPLATE_HEADER_FILE_NAME="head"

local TEMPLATE_FOOTER_FILE_NAME="foot"

# --------------------------------

markdown()
{
	cat $TEMPLATE_DIR/$TEMPLATE_HEADER_FILE_NAME.html > $OUTPUT
	perl $PATH_TO_MARKDOWN --html4tags $INPUT >> $OUTPUT
	cat $TEMPLATE_DIR/$TEMPLATE_FOOTER_FILE_NAME.html >> $OUTPUT
}

rm -rf $OUTPUT_DIR

# Generate content
for FILE_PATH in $(find $CONTENT_DIR -iname "*.$CONTENT_FILE_EXTENSION" | grep -v "$HOME_PAGE_FILE_NAME.$CONTENT_FILE_EXTENSION")
do
	local INPUT=$FILE_PATH

	FILE_PATH=${FILE_PATH%.markdown}
	FILE_PATH=${FILE_PATH#$CONTENT_DIR/}
	FILE_PATH=$OUTPUT_DIR/$FILE_PATH
	mkdir -p $FILE_PATH
	echo $FILE_PATH

	local OUTPUT=$FILE_PATH/index.html
	markdown
	echo $OUTPUT
done

# Generate home page
FILE_PATH=$CONTENT_DIR/$HOME_PAGE_FILE_NAME.$CONTENT_FILE_EXTENSION
if [ -d $TEMPLATE_DIR/$HOME_PAGE_TEMPLATE_DIR ]; then
	if [ -f "$TEMPLATE_DIR/$HOME_PAGE_TEMPLATE_DIR/$TEMPLATE_HEADER_FILE_NAME.html" ]; then 
		TEMPLATE_HEADER_FILE_NAME=$HOME_PAGE_TEMPLATE_DIR/$TEMPLATE_HEADER_FILE_NAME
	fi

	if [ -f "$TEMPLATE_DIR/$HOME_PAGE_TEMPLATE_DIR/$TEMPLATE_FOOTER_FILE_NAME.html" ]; then 
		TEMPLATE_FOOTER_FILE_NAME=$HOME_PAGE_TEMPLATE_DIR/$TEMPLATE_FOOTER_FILE_NAME
	fi
fi

if [ -f $FILE_PATH ]
then
	local INPUT=$FILE_PATH
	local OUTPUT=$OUTPUT_DIR/index.html
	markdown
	echo $OUTPUT
fi

exit 0
