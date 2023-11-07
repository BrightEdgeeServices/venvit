& ${env:SCRIPTS_DIR}\rte-db_clean_cache.ps1
reahl dropdb -y etc
pip install --no-deps -e .
reahl createdbuser etc
reahl createdb etc
reahl createdbtables etc
Get-ChildItem