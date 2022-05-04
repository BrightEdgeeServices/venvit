@ECHO ON 
pip install reahl[all]
cd d:\Dropbox\Projects
rd /S /Q d:\Dropbox\Projects\hello
reahl example tutorial.hello
cd d:\Dropbox\Projects\hello
xcopy /S /Q aD:\Dropbox\Projects\reahl\reahl-doc\reahl\doc\examples\tutorial\hello .
python -m pip install --no-deps -e .
reahl createdbuser etc
reahl createdb etc
reahl createdbtables etc
