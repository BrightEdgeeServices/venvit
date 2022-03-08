@ECHO ON
pip3 install reahl[all]
cd d:\Dropbox\Projects
rd /S /Q d:\Dropbox\Projects\bootstrapgrids
reahl example tutorial.bootstrapgrids
cd bootstrapgrids
