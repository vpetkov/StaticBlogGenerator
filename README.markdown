### This is a simple shell script that converts plain text files with Markdown formatting to static html pages using a template.

-------------------------------------------------

### Options

Run `generate.sh` with the following options:  
`-g`: Generate content pages.  
`-d`: Deploy.  
`-v`: Verbose.  
`-q`: Quiet.  
`-f`: Generate feed: _Experimental: Currently only RSS is supported_

-------------------------------------------------

#### The script uses John Grubers's [Markdown](http://daringfireball.net/projects/markdown/) to convert plain text to html.

### Configuration

**CONFIG_FILE_NAME** is the name of the configuration file (default is `site.conf`). The configuration file is stored either in the home directory or the current directory the script is executed. This variable can be changed from the script file `generate.sh`.

The rest of the configuration is stored in the configuration file.

#### Current version supports the following configurable variables:

**SITE_TITLE** is used in the websites title and for the feed generation.

**SITE_URL** is the default url for the home page it is used for the feed generation and also for the title href.

**SITE_DESCRIPTION** is placed below the title and is used for the feed generation

**DEPLOY_DIR** is the location for public html.

**DEPLOY_USER** and **DEPLOY_HOST** are the user and host for the `rsync` command to deploy the generated files directly to a server location.
Do not set those two if you want to use local folder or if you sync/deploy via FUSE.

**OUTPUT_DIR** is where local newly generated static html files will be placed. Files will be generated according to the directory structure in the **CONTENT_DIR** as follows:  
`CONTENT_DIR/category/sub-category/filename.markdown` will result a static html file:  
`OUTPUT_DIR/category/sub-category/filename/index.html`

This is a temporary folder and will be removed after deploying to **DEPLOY_DIR**.  
I suggest using the `-g` option without `-d` the first time so you can use **OUTPUT_DIR** to check if everything is OK before deploy.  

#### **TODO**: Currently the script wipes out completely the **OUTPUT_DIR** before generating new content. In the future this default behavior will be fixed and only new content will be generated unless explicitly otherwise noted.

**CONTENT_DIR** is the location for plain text files. Each one will be a new html file. The script supports sub-directories.  
**Tip**: _I use local configuration file in my **CONTENT_DIR** which is on Dropbox and I run the script from there._

**CONTENT_FILE_EXTENSION** is the extension for plain text content files. Only files with this extension in the **CONTENT_DIR** will be taken into account. Default extension is `.markdown` so that other files like `.txt` or `.todo` can be stored in the **CONTENT_DIR**.

**PATH_TO_MARKDOWN** is the location of the Markdown script. By default this repo has the Markdown script and this variable is set correctly.

**HOME_PAGE_FILE_NAME** is the file containing the home page content e.g. `OUTPUT_DIR/index.html`  
**Note**: _The script doesn't auto-generate index of all blog posts/journal entries for the home page. Instead the user can specify the content. That's because I prefer to manually specify what content goes on the home page._

**SIDEBAR_FILE_NAME** is the file with the content for the sidebar

**FOOTER_FILE_NAME** is the file with the footer content.

**FEED_FILE_NAME** contains feed entry description.

**FEED_TYPE** is the type of feed to be generated (rss/atom..)  
**Note** _The script supports only RSS feed.

**RSS_CHANEL_TITLE**, **RSS_CHANEL_LINK**, **RSS_CHANEL_DESCRIPTION**, **RSS_LANGUAG**, **RSS_WEB_MASTER**, **RSS_TTL** and *RSS_DATE** are still in **experimental** state and I don't recommend anyone use the `-f` option to generate RSS feed with this script. This feature will remain fairly limited for the purposes of my own blog. At least for the time being.


Also the **example** directory contains sample files and the script is supposed to work out of the box and be able to generate the example.
To setup just remove the example directory, edit the configuration file and generate your site.
NOTE: Don't forget to copy the markdown directory with the script.

-------------------------------------------------

### For questions, suggestions, help: [mail@vpetkov.com](mailto:mail@vpetkov.com)

