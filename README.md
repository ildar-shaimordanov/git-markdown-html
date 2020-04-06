# git-markdown-html

Convert Github markdown to HTML

<!-- md-toc-begin -->
# Table of Content
* [git-markdown-html](#git-markdown-html)
* [NAME](#name)
* [SYNOPSIS](#synopsis)
* [DESCRIPTION](#description)
* [SEE ALSO](#see-also)
<!-- md-toc-end -->

# NAME

`git-md-html` - convert GitHub markdown to HTML

# SYNOPSIS

    git-md-html [FILENAME]

# DESCRIPTION

`git-md-html` assumes an input as the Github markdown and converts it to
HTML. Data can be read from a file, pipe or redirection and displays
results to the standard output. You can redirect the output to another
file or another process (if needs). Internally the script uses pandoc
as the many-to-many converter.

# SEE ALSO

Pandoc home page:
https://pandoc.org

The idea to develop this script was inspired by the JFL's script:
https://github.com/JFLarvoire/SysToolsLib/blob/master/Batch/md2h.bat

As well as his script this one uses Github Markdown Stylesheet:
https://gist.github.com/tuzz/3331384
