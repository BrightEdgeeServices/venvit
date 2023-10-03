@ECHO %1 
git init 
pip install --upgrade --force pre-commit 
pre-commit install 
pre-commit autoupdate 
