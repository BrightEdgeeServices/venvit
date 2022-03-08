@ECHO ON
pip3 install reahl[all]
cd d:\Dropbox\Projects
rd /S /Q d:\Dropbox\Projects\addresslist
reahl example tutorial.addresslist
cd addresslist
