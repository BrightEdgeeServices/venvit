@ECHO ON
pip3 install reahl[all]
cd d:\Dropbox\Projects
rd /S /Q d:\Dropbox\Projects\addressbook2
reahl example tutorial.addressbook2
cd addressbook2
