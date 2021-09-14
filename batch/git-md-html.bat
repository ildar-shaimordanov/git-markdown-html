:::NAME
:::
:::    git-md-html - convert markdown to HTML
:::
:::SYNOPSIS
:::
:::    git-md-html [OPTIONS] [FILENAME]
:::
:::DESCRIPTION
:::
:::git-md-html assumes an input as a markdown text and converts it to
:::HTML. Data can be read from a file, pipe or redirection, and results
:::default to the standard output. You can redirect the output to another
:::file or another process (if needs).
:::
:::If one of the options -u/-U is specified, converting is performed
:::with help of GitHub API (defaults to the public GitHub API).
:::
:::In this case curl or wget (the first found) is used to communicate
:::with the selected Git host.
:::
:::If no more options specified, the script will tries to complete this
:::action invoking pandoc, the cool many-to-many offline converter.
:::
:::OPTIONS
:::
:::  -u             Use the public GitHub API by https://api.github.com
:::  -U URL         Use another GitHub API URL
:::  -t TOKEN-FILE  Specify a filename to read a token from
:::  -T TOKEN       Specify the token
:::
:::SEE ALSO
:::
:::Pandoc home page
:::https://pandoc.org
:::
:::The idea to develop this script was inspired by the JFL's script:
:::https://github.com/JFLarvoire/SysToolsLib/blob/master/Batch/md2h.bat
:::
:::As well as his script this one uses Github Markdown Stylesheet:
:::https://gist.github.com/tuzz/3331384
:::
:::Yet another Perl converter:
:::https://github.com/brxfork/md2html
:::
:::COPYRIGHT
:::
:::Copyright (c) 2019-2021 Ildar Shaimordanov. All rights reserved.
:::
:::  MIT License

@echo off

setlocal

set "GITHUB_API_URL=https://api.github.com"

set "SRCFILE=-"
set "PAGE_TITLE={STDIN}"

set "API_URL="
set "TOKEN="

:: ========================================================================

:parse_options
timeout /t 0 >nul 2>&1 && if "%~1" == "" (
	call :print_usage >&2
	goto :EOF
)

if "%~1" == "-u" (
	set "API_URL=%GITHUB_API_URL%"
	shift /1
) else if "%~1" == "-U" (
	set "API_URL=%~2"
	shift /1
	shift /1
)

if "%~1" == "-t" (
	for %%f in ( "%~2" ) do set "API_TOKEN=%%f"
	shift /1
	shift /1
) else if "%~1" == "-T" (
	set "API_TOKEN=%~2"
	shift /1
	shift /1
)

if not "%~1" == "" (
	set "SRCFILE=%~1"
	set "PAGE_TITLE=%~nx1 (%~f1)"
)

:: ========================================================================

if defined API_URL (
	call :conv_online
) else (
	call :conv_offline
)

goto :EOF

:: ========================================================================

:conv_online
set "URL=%API_URL%/markdown/raw"

set "AUTH_HEADER="
if defined TOKEN set "AUTH_HEADER=--header "Authorization: token %TOKEN%""

for %%f in ( curl.exe wget.exe ) do if not "%%~$PATH:f" == "" (
	call :html_begin
	call :html_css
	call :dl_%%~nf "%SRCFILE%"
	call :html_end
	goto :EOF
)

call :die "curl or wget not found"
goto :EOF


:dl_curl
curl --insecure -s "%URL%" ^
	--request POST --data-binary "@%~1" ^
	--header "Content-Type: text/plain" ^
	%AUTH_HEADER%

goto :EOF


:dl_wget
if "%~1" == "-" (
	set "TEMPFILE=%TEMP%/%~n0.%RANDOM%"
	more > "%TEMPFILE%"
	call :dl_wget "%TEMPFILE%"
	del /q "%TEMPFILE%"
	goto :EOF
)

wget --no-check-certificate -qO - "%URL%" ^
	--post-file="%~1" ^
	--header "Content-Type: text/plain" ^
	%AUTH_HEADER%

goto :EOF

:: ========================================================================

:conv_offline
for %%f in ( pandoc.exe ) do if "%%~$PATH:f" == "" (
	die "pandoc not found. Try with -u/-U to request git API"
	goto :EOF
)

call :html_begin
call :html_css

pandoc --from=gfm --to=html "%SRCFILE%"

call :html_end

goto :EOF

:: ========================================================================

:html_begin
echo:^<!DOCTYPE html^>
echo:^<html xmlns="http://www.w3.org/1999/xhtml" lang xml:lang^>
echo:^<head^>
echo:^<meta charset="utf-8" /^>
echo:^<title^>%PAGE_TITLE%^</title^>
echo:^</head^>
echo:^<body^>
goto :EOF

:html_css
echo:^<style type="text/css"^>
set "CSS_FOUND="
for /f "usebackq tokens=* delims=" %%s in ( "%~f0" ) do (
	if defined CSS_FOUND echo:%%s
	if "%%~s" == "__DATA__" set CSS_FOUND=1
)

echo:^</style^>
goto :EOF

:html_end
echo:^</body^>
echo:^</html^>
goto :EOF

:: ========================================================================

:die
call :warn "%~1"
exit /b 255

:warn
echo "%~1">&2
goto :EOF

:print_usage
for /f "tokens=* delims=:" %%s in ( 'findstr "^:::" "%~f0"' ) do echo:%%s
goto :EOF

:: ========================================================================

:: EOF

:: Style sheet from https://gist.github.com/tuzz/3331384
__DATA__
/*
Copyright (c) 2017 Chris Patuzzo
https://twitter.com/chrispatuzzo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

body {
  font-family: Helvetica, arial, sans-serif;
  font-size: 14px;
  line-height: 1.6;
  padding-top: 10px;
  padding-bottom: 10px;
  background-color: white;
  padding: 30px;
  color: #333;
}

body > *:first-child {
  margin-top: 0 !important;
}

body > *:last-child {
  margin-bottom: 0 !important;
}

a {
  color: #4183C4;
  text-decoration: none;
}

a.absent {
  color: #cc0000;
}

a.anchor {
  display: block;
  padding-left: 30px;
  margin-left: -30px;
  cursor: pointer;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
}

h1, h2, h3, h4, h5, h6 {
  margin: 20px 0 10px;
  padding: 0;
  font-weight: bold;
  -webkit-font-smoothing: antialiased;
  cursor: text;
  position: relative;
}

h2:first-child, h1:first-child, h1:first-child + h2, h3:first-child, h4:first-child, h5:first-child, h6:first-child {
  margin-top: 0;
  padding-top: 0;
}

h1:hover a.anchor, h2:hover a.anchor, h3:hover a.anchor, h4:hover a.anchor, h5:hover a.anchor, h6:hover a.anchor {
  text-decoration: none;
}

h1 tt, h1 code {
  font-size: inherit;
}

h2 tt, h2 code {
  font-size: inherit;
}

h3 tt, h3 code {
  font-size: inherit;
}

h4 tt, h4 code {
  font-size: inherit;
}

h5 tt, h5 code {
  font-size: inherit;
}

h6 tt, h6 code {
  font-size: inherit;
}

h1 {
  font-size: 28px;
  color: black;
}

h2 {
  font-size: 24px;
  border-bottom: 1px solid #cccccc;
  color: black;
}

h3 {
  font-size: 18px;
}

h4 {
  font-size: 16px;
}

h5 {
  font-size: 14px;
}

h6 {
  color: #777777;
  font-size: 14px;
}

p, blockquote, ul, ol, dl, li, table, pre {
  margin: 15px 0;
}

hr {
  border: 0 none;
  color: #cccccc;
  height: 4px;
  padding: 0;
}

body > h2:first-child {
  margin-top: 0;
  padding-top: 0;
}

body > h1:first-child {
  margin-top: 0;
  padding-top: 0;
}

body > h1:first-child + h2 {
  margin-top: 0;
  padding-top: 0;
}

body > h3:first-child, body > h4:first-child, body > h5:first-child, body > h6:first-child {
  margin-top: 0;
  padding-top: 0;
}

a:first-child h1, a:first-child h2, a:first-child h3, a:first-child h4, a:first-child h5, a:first-child h6 {
  margin-top: 0;
  padding-top: 0;
}

h1 p, h2 p, h3 p, h4 p, h5 p, h6 p {
  margin-top: 0;
}

li p.first {
  display: inline-block;
}

ul, ol {
  padding-left: 30px;
}

ul :first-child, ol :first-child {
  margin-top: 0;
}

ul :last-child, ol :last-child {
  margin-bottom: 0;
}

dl {
  padding: 0;
}

dl dt {
  font-size: 14px;
  font-weight: bold;
  font-style: italic;
  padding: 0;
  margin: 15px 0 5px;
}

dl dt:first-child {
  padding: 0;
}

dl dt > :first-child {
  margin-top: 0;
}

dl dt > :last-child {
  margin-bottom: 0;
}

dl dd {
  margin: 0 0 15px;
  padding: 0 15px;
}

dl dd > :first-child {
  margin-top: 0;
}

dl dd > :last-child {
  margin-bottom: 0;
}

blockquote {
  border-left: 4px solid #dddddd;
  padding: 0 15px;
  color: #777777;
}

blockquote > :first-child {
  margin-top: 0;
}

blockquote > :last-child {
  margin-bottom: 0;
}

table {
  padding: 0;
}
table tr {
  border-top: 1px solid #cccccc;
  background-color: white;
  margin: 0;
  padding: 0;
}

table tr:nth-child(2n) {
  background-color: #f8f8f8;
}

table tr th {
  font-weight: bold;
  border: 1px solid #cccccc;
  text-align: left;
  margin: 0;
  padding: 6px 13px;
}

table tr td {
  border: 1px solid #cccccc;
  text-align: left;
  margin: 0;
  padding: 6px 13px;
}

table tr th :first-child, table tr td :first-child {
  margin-top: 0;
}

table tr th :last-child, table tr td :last-child {
  margin-bottom: 0;
}

img {
  max-width: 100%;
}

span.frame {
  display: block;
  overflow: hidden;
}

span.frame > span {
  border: 1px solid #dddddd;
  display: block;
  float: left;
  overflow: hidden;
  margin: 13px 0 0;
  padding: 7px;
  width: auto;
}

span.frame span img {
  display: block;
  float: left;
}

span.frame span span {
  clear: both;
  color: #333333;
  display: block;
  padding: 5px 0 0;
}

span.align-center {
  display: block;
  overflow: hidden;
  clear: both;
}

span.align-center > span {
  display: block;
  overflow: hidden;
  margin: 13px auto 0;
  text-align: center;
}

span.align-center span img {
  margin: 0 auto;
  text-align: center;
}

span.align-right {
  display: block;
  overflow: hidden;
  clear: both;
}

span.align-right > span {
  display: block;
  overflow: hidden;
  margin: 13px 0 0;
  text-align: right;
}

span.align-right span img {
  margin: 0;
  text-align: right;
}

span.float-left {
  display: block;
  margin-right: 13px;
  overflow: hidden;
  float: left;
}

span.float-left span {
  margin: 13px 0 0;
}

span.float-right {
  display: block;
  margin-left: 13px;
  overflow: hidden;
  float: right;
}

span.float-right > span {
  display: block;
  overflow: hidden;
  margin: 13px auto 0;
  text-align: right;
}

code, tt {
  margin: 0 2px;
  padding: 0 5px;
  white-space: nowrap;
  border: 1px solid #eaeaea;
  background-color: #f8f8f8;
  border-radius: 3px;
}

pre code {
  margin: 0;
  padding: 0;
  white-space: pre;
  border: none;
  background: transparent;
}

.highlight pre {
  background-color: #f8f8f8;
  border: 1px solid #cccccc;
  font-size: 13px;
  line-height: 19px;
  overflow: auto;
  padding: 6px 10px;
  border-radius: 3px;
}

pre {
  background-color: #f8f8f8;
  border: 1px solid #cccccc;
  font-size: 13px;
  line-height: 19px;
  overflow: auto;
  padding: 6px 10px;
  border-radius: 3px;
}

pre code, pre tt {
  background-color: transparent;
  border: none;
}
