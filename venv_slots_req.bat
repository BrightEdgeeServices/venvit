@ECHO ON
pip3 install reahl[all]
cd d:\Dropbox\Projects
rd /S /Q d:\Dropbox\Projects\slots
reahl example tutorial.slots
cd slots
