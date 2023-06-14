reahl dropdb -y etc
rd /S /Q rte_db.egg-info
rd /S /Q src\__pycache__
pip install --no-deps -e .
reahl createdbuser etc
reahl createdb etc
reahl createdbtables etc
