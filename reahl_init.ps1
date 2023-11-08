reahl dropdb -y etc
pip install --no-deps -e .
reahl createdbuser etc
reahl createdb etc
reahl createdbtables etc
