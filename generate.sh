#!/bin/sh

# Author: Vesselin Petkov <mail@vpetkov.com>
# Version: 2.1
# http://github.com/vpetkov/StaticBlogGenerator
#
# For help on configuration refer to http://github.com/vpetkov/StaticBlogGenerator#readme


# --- Configurable variables -----

# Change the name of the configuration file
CONFIG_FILE_NAME="site.conf"
# IMPORTANT: This is just the name of the file. The directory
# where it is stored can be either the $HOME or $PWD.
# The latter is useful for multiple site configurations.

# --------------------------------

load_configuration()
{
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
}

markdown()
{
	perl $PATH_TO_MARKDOWN $INPUT >> $OUTPUT
	echo "\n" >> $OUTPUT
}

html_head()
{
	echo "<html>\n" > $OUTPUT
	echo "    <head>\n" >> $OUTPUT
	echo "        <title>$SITE_TITLE</title>" >> $OUTPUT
	cat "$CONTENT_DIR/$HEAD_FILE_NAME" >> $OUTPUT
	echo "    </head>\n" >> $OUTPUT
	echo "    <body>\n" >> $OUTPUT
}

html_main()
{
	echo "        <div id=\"wrap\">\n" >> $OUTPUT
	echo "            <div id=\"title\"><a href=\"$SITE_URL\"><h1>$SITE_TITLE</h1></a></div>\n" >> $OUTPUT
	echo "            <div id=\"main\" class=\"$1\">\n" >> $OUTPUT
	markdown
	echo "            </div>\n" >> $OUTPUT
}

html_sidebar()
{
	local INPUT="$CONTENT_DIR/$SIDEBAR_FILE_NAME"
	echo "            <div id=\"side\">\n" >> $OUTPUT
	markdown
	echo "            </div>\n" >> $OUTPUT
}

html_footer()
{
	local INPUT="$CONTENT_DIR/$FOOTER_FILE_NAME"
	echo "            <div id=\"footer\">\n" >> $OUTPUT
	markdown
	echo "            </div>\n" >> $OUTPUT
}

html_end()
{
	echo "    </body>\n" >> $OUTPUT
	echo "</html>\n" >> $OUTPUT
}

generate()
{
	[ "${QUIET:-0}" -eq 0 ] && echo "Generate content..."

	rm -rf $OUTPUT_DIR

	for FILE_PATH in $(find $CONTENT_DIR -iname "*.$CONTENT_FILE_EXTENSION" |
		grep -v "$HOME_PAGE_FILE_NAME\|$FEED_FILE_NAME\|$SIDEBAR_FILE_NAME\|$FOOTER_FILE_NAME")
	do
		local INPUT=$FILE_PATH

		FILE_PATH=${FILE_PATH%.$CONTENT_FILE_EXTENSION}
		FILE_PATH=${FILE_PATH#$CONTENT_DIR/}
		FILE_PATH="$OUTPUT_DIR/$FILE_PATH"
		mkdir -p $FILE_PATH
		[ "${VERBOSE:-0}" -ge 1 ] && echo $FILE_PATH

		local OUTPUT="$FILE_PATH/index.html"

		html_head
		html_main("article")
		[ -n "$FOOTER_FILE_NAME" ] && html_footer
		html_end

		[ "${VERBOSE:-0}" -ge 1 ] && echo $OUTPUT
	done

	[ "${QUIET:-0}" -eq 0 ] && echo "Generate home page..."

	FILE_PATH="$CONTENT_DIR/$HOME_PAGE_FILE_NAME"

	if [ -f $FILE_PATH ]
	then
		local INPUT=$FILE_PATH
		local OUTPUT="$OUTPUT_DIR/index.html"

		html_head
		html_main("home")
		[ -n "$SIDEBAR_FILE_NAME" ] && html_sidebar
		[ -n "$FOOTER_FILE_NAME" ] && html_footer
		html_end

		[ "${VERBOSE:-0}" -ge 1 ] && echo $OUTPUT
	fi
}

deploy()
{
	[ "${QUIET:-0}" -eq 0 ] && echo "Deploy..."

	if [ -z $DEPLOY_USER ] && [ -z $DEPLOY_HOST ] && [ -d $OUTPUT_DIR ] && [ -d $DEPLOY_DIR ]
	then
		cp -rf $([ "${VERBOSE:-0}" -ge 1 ] && echo "-v") $OUTPUT_DIR/* $DEPLOY_DIR/

	elif [ ! -z $DEPLOY_USER ] && [ ! -z $DEPLOY_HOST ] && [ -d $OUTPUT_DIR ] && [ -d $DEPLOY_DIR ]
	then
		rsync -r $([ "${VERBOSE:-0}" -ge 1 ] && echo "-v") $OUTPUT_DIR/* $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_DIR/
	fi
}

generate_deploy_rss_feed()
{
	RSS_DATE="`date +${RSS_DATE_FORMAT}`"

	RSS_ITEM_TITLE=$(head -1 "$CONTENT_DIR/$FEED_FILE_NAME" | grep -o "\[.\+\]" | tr -d "[]")
	RSS_ITEM_LINK=$(head -1 "$CONTENT_DIR/$FEED_FILE_NAME" | grep -o "(.\+)" | tr -d "()")

	local INPUT=mktemp
	tail --lines=+2 "$CONTENT_DIR/$FEED_FILE_NAME" > $INPUT

	local OUTPUT=mktemp
	markdown

	RSS_ITEM_DESCRIPTION=$OUTPUT

	mkdir -p $DEPLOY_DIR/$FEED_FILE_NAME
	$RSS_FILE="$DEPLOY_DIR/$FEED_FILE_NAME/index.xml"

	echo "<?xml version="1.0"?>\n" > $RSS_FILE

	echo "<rss version="2.0">\n" >> $RSS_FILE
	echo "   <channel>\n" >> $RSS_FILE
	echo "	  <title>${RSS_CHANEL_TITLE}</title>\n" >> $RSS_FILE
	echo "	  <link>${RSS_CHANEL_LINK}</link>\n" >> $RSS_FILE
	echo "	  <description>${RSS_CHANEL_DESCRIPTION}</description>\n" >> $RSS_FILE
	echo "	  <language>${RSS_LANGUAGE}</language>\n" >> $RSS_FILE
	echo "	  <ttl>${RSS_TTL}</ttl>\n" >> $RSS_FILE
	echo "	  <pubDate>${RSS_DATE}</pubDate>\n" >> $RSS_FILE
	echo "	  <lastBuildDate>${RSS_DATE}</lastBuildDate>\n" >> $RSS_FILE
	echo "	  <docs>http://blogs.law.harvard.edu/tech/rss</docs>\n" >> $RSS_FILE
	echo "	  <generator>$RSS_GENERATOR</generator>\n" >> $RSS_FILE
	echo "	  <webMaster>${RSS_WEB_MASTER}</webMaster>\n" >> $RSS_FILE
	echo "	  <item>\n" >> $RSS_FILE
	echo "		 <title>${RSS_ITEM_TITLE}</title>\n" >> $RSS_FILE
	echo "		 <link>${RSS_ITEM_LINK}</link>\n" >> $RSS_FILE
	echo "		 <description>" >> $RSS_FILE
	cat $RSS_ITEM_DESCRIPTION >> RSS_FILE
	echo "</description>\n" >> $RSS_FILE
	echo "		 <pubDate>${RSS_DATE}</pubDate>\n" >> $RSS_FILE
	echo "		 <guid>${RSS_ITEM_LINK}</guid>\n" >> $RSS_FILE
	echo "	  </item>\n" >> $RSS_FILE
	echo "   </channel>\n" >> $RSS_FILE
	echo "</rss>\n" >> $RSS_FILE

	[ "${VERBOSE:-0}" -ge 1 ] && echo $RSS_FILE
}

feed()
{
	[ "${QUIET:-0}" -eq 0 ] && echo "Generate new feed..."

	if [ $(echo $FEED_TYPE | tr '[:upper:]' '[:lower:]') -eq "rss" ]
	then
		generate_deploy_rss_feed()
	else
		[ "${QUIET:-0}" -eq 0 ] && echo "$FEED_TYPE feed not supported."
	fi
}

# Get options
while getopts vqgdf opts; do
	case "$opts" in
	v)	VERBOSE=1 ;;
	q)	QUIET=1 ;;
	g)	DO_GENERATE=1 ;;
	d)	DO_DEPLOY=1 ;;
	f)	DO_FEED=1 ;;
	esac
done

load_configuration
[ "${DO_GENERATE:-0}" -eq 1 ] && generate
[ "${DO_DEPLOY:-0}" -eq 1 ] && deploy
[ "${DO_FEED:-0}" -eq 1 ] && feed
[ "${QUIET:-0}" -eq 0 ] && echo "Done."

exit 0
