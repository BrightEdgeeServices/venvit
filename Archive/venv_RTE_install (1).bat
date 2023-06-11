@ECHO %2 
@ECHO Running venv_RTE_install.bat...
git init
pip install --upgrade --force black
pip install --upgrade --force flake8
pip install --upgrade --force pre-commit
pre-commit install
pre-commit autoupdate
python -m pip install --upgrade reahl[declarative,sqlite,mysql,dev,doc]
IF EXIST "d:\GoogleDrive\Projects\RTE\RTE\pyproject.toml" pip install -e .
