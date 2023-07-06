rd /S /Q parameterised2.egg-info
rd /S /Q rte_db.egg-info
rd /S /Q __pycache__
rd /S /Q .pytest_cache
rd /S /Q parameterised2_dev\__pycache__
rd /S /Q etc\__pycache__
rd /S /Q src\__pycache__
rd /S /Q src\rte_db.egg-info
rd /S /Q src\tables\__pycache__
rd /S /Q tests\__pycache__
del desktop.ini /S /Q /A:H

reahl dropdb -y etc
pip install --no-deps -e .
reahl createdbuser etc
reahl createdb etc
reahl createdbtables etc
