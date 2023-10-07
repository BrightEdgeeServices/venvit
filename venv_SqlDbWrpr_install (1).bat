@ECHO %2 
@ECHO Running venv_SqlDbWrpr_install.bat...
git init
pip install --upgrade --force black
pip install --upgrade --force flake8
pip install --upgrade --force pre-commit
pre-commit install
pre-commit autoupdate
IF EXIST "D:\Dropbox\Projects\BEE\SqlDbWrpr\pyproject.toml" pip install -e .
