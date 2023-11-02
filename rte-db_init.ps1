& ${env:SCRIPTS_DIR}\rte-db_clean_cache.bat
reahl dropdb -y etc
pip install --no-deps -e .
reahl createdbuser etc
reahl createdb etc
reahl createdbtables etc
