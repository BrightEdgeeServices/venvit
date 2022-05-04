@ECHO ON 
@ECHO ON
pip install reahl[all]
cd d:\Dropbox\Projects
cd d:\Dropbox\Projects\rteRestAPI
python -m pip install --no-deps -e .
reahl createdbuser etc
reahl createdb etc
reahl createdbtables etc
