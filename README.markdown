### This is a simple shell script that converts plain text files with Markdown formatting to static html pages using a template.

-------------------------------------------------

### Options

Run `generate.sh` with the following options:  
`-g`: Generate content pages.  
`-d`: Deploy.  
`-v`: Verbose.
`-q`: Quiet.

-------------------------------------------------

#### The script uses John Grubers's [Markdown](http://daringfireball.net/projects/markdown/) to convert plain text to html.

### Configuration

**CONFIG_FILE_NAME** - the name of the configuration file (default is `.blog`). The configuration file is stored either in the home directory or the current directory the script is executed. This variable can be changed from the script file `generate.sh`.

The rest of the configuration is stored in the configuration file.

#### Current version supports the following configurable variables:

**DEPLOY_DIR** - the location of public html dir.

**DEPLOY_USER** and **DEPLOY_HOST** - user and host for the `rsync` command to deploy the generated files directly to a server location.
Do not set those two if you want to use local folder or if you sync/deploy via fuse or something.

**OUTPUT_DIR** - the location for newly generated static html files. Files will be put according to the directory structure in the **CONTENT_DIR** as follows:  
`CONTENT_DIR/category/sub-category/filename.markdown` will result a static html file:  
`OUTPUT_DIR/category/sub-category/filename/index.html`

This is a temporary folder but you can use it to check if everything is OK before deploy.

#### **TODO**: Currently the script wipes out completely the **OUTPUT_DIR** before generating new content. In the following versions this default behavior will be fixed and only new content will be generated unless explicitly otherwise noted.

**CONTENT_DIR** - the location for plain text files. Each one will be a new html file. The script supports sub-directories.  
#### **Tip**: I use local configuration file in my Dropbox folder and run the script from there.

**CONTENT_FILE_EXTENSION** - the default extension for plain text content files. Only files with this extension in the **CONTENT_DIR** will be taken into account. Default extension is _.markdown_ so that other files like _.txt_ can be stored as _readme_ or _draft_ files.

**HOME_PAGE_FILE_NAME** - the file containing the come page content e.g. `OUTPUT_DIR/index.html`

Next few variables are not recommended for reconfiguration. However nothing bad would happen.

**PATH_TO_MARKDOWN** - the location of the Markdown script. By default this repo has the Markdown script and this variable is not recommended to be changed.

**TEMPLATE_DIR** - the location for the template used to html pages. Currently the script supports two separate files one for the html before the content and one for the html after the content. Templates file names are `head.html` and `foot.html` - this idea is taken from [Blosxom](http://www.blosxom.com/).

**HOME_PAGE_TEMPLATE_DIR** - the location for home page specific templates. Default is **TEMPLATE_DIR**/**HOME_PAGE_FILE_NAME**. If suitable template files aren't found for the home page the default ones will be used.

**TEMPLATE_HEADER_FILE_NAME** and **TEMPLATE_FOOTER_FILE_NAME** hold the information for template file names.

#### My template files are available here: [StaticBlogTemplates](https://github.com/vpetkov/StaticBlogTemplates)

Also the **example** directory contains sample files and the script is supposed to work out of the box and be able to generate the example.
To use remove the example directory, edit the configuration file and generate your blog.
NOTE: Don't forget to copy the markdown directory with the script.

-------------------------------------------------

### For questions, suggestions, help: [mail@vpetkov.com](mailto:mail@vpetkov.com)

