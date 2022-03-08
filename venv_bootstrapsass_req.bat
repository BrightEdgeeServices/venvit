@ECHO ON
pip3 install reahl[all]
cd ..
rd /S /Q d:\Dropbox\Projects\bootstrapsass
reahl example howtos.bootstrapsass
cd bootstrapsass
