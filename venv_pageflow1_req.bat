@ECHO ON
pip3 install reahl[all]
cd d:\Dropbox\Projects
rd /S /Q d:\Dropbox\Projects\pageflow1
reahl example tutorial.pageflow1
cd pageflow1
