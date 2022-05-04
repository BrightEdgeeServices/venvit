@ECHO ON
pip install reahl[all]
cd d:\Dropbox\Projects
rd /S /Q d:\Dropbox\Projects\addressbook1
reahl example tutorial.addressbook1
cd d:\Dropbox\Projects\addressbook1
xcopy /S /Q D:\Dropbox\Projects\reahl\reahl-doc\reahl\doc\examples\tutorial\addressbook1 .
python -m pip install --no-deps -e .
reahl createdbuser etc
reahl createdb etc
reahl createdbtables etc
REM areahl serve etc
