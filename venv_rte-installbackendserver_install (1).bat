@ECHO %2 
@ECHO Running venv_rte-installbackendserver_install.bat...
git init
pip install --upgrade --force black
pip install --upgrade --force flake8
pip install --upgrade --force pre-commit
pre-commit install
pre-commit autoupdate
IF EXIST "d:\Dropbox\Projects\RTE\rte-installbackendserver\pyproject.toml" pip install -e .
