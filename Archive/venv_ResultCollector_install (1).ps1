Write-Host "Running venv_ResultCollector_install.ps1..." -ForegroundColor Yellow
git init
pip install --upgrade --force --no-cache-dir black
pip install --upgrade --force --no-cache-dir flake8
pip install --upgrade --force --no-cache-dir pre-commit
pre-commit install
pre-commit autoupdate
D:\Dropbox\Projects\RTE\ResultCollector\install.ps1
