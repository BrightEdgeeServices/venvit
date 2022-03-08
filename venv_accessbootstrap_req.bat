@ECHO ON
pip3 install reahl[declarative,sqlite,dev,doc]
cd ..
rd /S /Q d:\Dropbox\Projects\accessbootstrap
pause
reahl example tutorial.accessbootstrap
cd accessbootstrap
pause
