<!-- md-toc-begin -->
# Table of Content
* [NAME](#name)
* [SYNOPSIS](#synopsis)
* [DESCRIPTION](#description)
* [OPTIONS](#options)
* [SEE ALSO](#see-also)
* [COPYRIGHT](#copyright)
<!-- md-toc-end -->

# NAME

`git-md-html` - convert markdown to HTML

# SYNOPSIS

    git-md-html [OPTIONS] [FILENAME]

# DESCRIPTION

There is set of scripts making attempt to convert a markdown text to HTML. Data can be read from a file, pipe or redirection, and results default to the standard output. You can redirect the output to another file or another process (if needs).

Despite of difference in implementation they have identical (or almost identical, at least I tried to follow this direction) user interface.

With the `-u` / `-U` options each script sends request to GitHub API (by default to the public GitHub API). Shell and batch scripts use `curl` or `wget` (the first one found). The Perl script uses `HTTP::Tiny`.

if no more options specified, the scripts try to complete convertion invoking `pandoc` (shell and batch) or `Text::Markdown` (Perl).

# OPTIONS

* `-h`, `--help`
  Print this help and exit.
* `-u`, `--github-api-url`
  Use the public GitHub API by https://api.github.com.
* `-U URL`, `--api-url=URL`
  Use another GitHub API URL.
* `-t TOKEN-FILE`, `--token-file=TOKEN-FILE`
  Specify a filename to read a token from.
* `-T TOKEN`, `--token=TOKEN`
  Specify the token.
* `-r`, `--raw`
  Raw output (no head, no CSS; html body only).

The short options are supported by the all implementations, the long options are supported by the Perl version of the script.

# SEE ALSO

* [Text::Markdown](https://metacpan.org/pod/Text::Markdown)
* [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny)
* Pandoc home page:
  https://pandoc.org
* The idea to develop this script was inspired by the JFL's script:
  https://github.com/JFLarvoire/SysToolsLib/blob/master/Batch/md2h.bat
* As well as his script this one uses Github Markdown Stylesheet:
  https://gist.github.com/tuzz/3331384
* Yet another Perl-written GitHub API based converter (one of many):
  https://github.com/brxfork/md2html
* Another GitLab API based converter (one of many):
  https://gitlab.triumf.ca/-/snippets/53

# COPYRIGHT

Copyright (c) 2019-2022 Ildar Shaimordanov. All rights reserved.

  MIT License
