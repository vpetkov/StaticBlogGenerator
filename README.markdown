### This is a simple shell script that converts plain text files to static html pages using a template.

### The script uses John Grubers's [Markdown](http://daringfireball.net/projects/markdown/) to convert plain text to html.

### Current version supports the following configurable variables:

__CONTENT_DIR__ - the location for plain text files. Each one will be a new html file. The script supports sub-directories.

__OUTPUT_DIR__ - the location for newly generated static html files. Files will be put according to the directory structure in the __CONTENT_DIR__ as follows:  
`CONTENT_DIR/category/sub-category/filename.markdown` will result a static html file:  
`OUTPUT_DIR/category/sub-category/filename/index.html`
####Note#### __TODO__: Currently the script wipes out completely the __OUTPUT_DIR__ before generating new content. In the following versions this default behavior will be fixed and only new content will be generated unless explicitly otherwise noted.

__CONTENT_FILE_EXTENSION__ - the default extension for plain text content files. Only files with this extension in the __CONTENT_DIR__ will be taken into account. Default extension is _.markdown_ so that other files like _.txt_ can be stored as readme or draft files.

__HOME_PAGE_FILE_NAME__ - the file containing the come page content e.g. `OUTPUT_DIR/index.html`

Next few variables are not recomended for reconfiguration. However nothing bad would happen.

__PATH_TO_MARKDOWN__ - the location of the Markdown script. By default this repo has the Markdown script and this variable is not recommended to be changed.

__TEMPLATE_DIR__ - the location for the template used to html pages. Currently the script supports two separate files one for the html before the content and one for the html ater the content. Templates file names are `head.html` and `foot.html` - this idea is taken from [Blosxom](http://www.blosxom.com/).

__TEMPLATE_HEADER_FILE_NAME__ and __TEMPLATE_FOOTER_FILE_NAME__ hold the information for template file names.

### For questions, suggestions, help: [mail@vpetkov.com](mailto:mail@vpetkov.com)
