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

local TEMPLATE_DIR="./templates"

local CONTENT_DIR="./content"

local OUTPUT_DIR="./html"

local PATH_TO_MARKDOWN="./markdown/Markdown.pl"

local CONTENT_FILE_EXTENSION="markdown"

# --------------------------------

rm -rf $OUTPUT_DIR

for FILE_PATH in $(find $CONTENT_DIR -iname "*.$CONTENT_FILE_EXTENSION")
do
	INPUT=$FILE_PATH
	FILE_PATH=${FILE_PATH%.markdown}
	FILE_PATH=${FILE_PATH#$CONTENT_DIR/}
	FILE_PATH=$OUTPUT_DIR/$FILE_PATH
	mkdir -p $FILE_PATH
	echo $FILE_PATH
	OUTPUT=${FILE_PATH}/index.html
	cat $TEMPLATE_DIR/head.html > ${OUTPUT}
	perl $PATH_TO_MARKDOWN --html4tags $INPUT >> ${OUTPUT}
	cat $TEMPLATE_DIR/foot.html >> ${OUTPUT}
	echo $OUTPUT
done

exit 0
