@ECHO ON
pip3 install reahl[all]
cd d:\Dropbox\Projects
rd /S /Q d:\Dropbox\Projects\addressbook1
reahl example tutorial.addressbook1
cd addressbook1
