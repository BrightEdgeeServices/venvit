@ECHO ON
CLS
ECHO Initialize "%1" virtual environment

set _python_base_dir="c:\Program Files Python"
set _venv_base_dir=d:\venv
set _batch_dir=d:\dropbox\batch
set _projects_dir=d:\Dropbox\Projects
@REM W5195935
if "%COMPUTERNAME%"=="W5202690" (
	set _python_base_dir=c:\Python
	set _venv_base_dir=c:\venv
	set _batch_dir=d:\batch
	set _projects_dir=d:\Projects
)

if "%1"=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)
if "%2"=="" (
    set /P _python_version="Python version: "
    ) else (
    set _python_version=%2
)

call deactivate
%_python_base_dir%\Python%_python_version%\python -m venv --clear %_venv_base_dir%\%_project_name%_env

if "%COMPUTERNAME%"=="W5202690" (
	copy "d:\Lib\Templates\pip.ini" %_venv_base_dir%\%_project_name%_env
)
call %_venv_base_dir%\%_project_name%_env\Scripts\activate.bat
echo on
python.exe -m pip install --upgrade pip

IF EXIST %_projects_dir%\%_project_name% (
	cd %_projects_dir%\%_project_name%
	pip install -r %_projects_dir%\%_project_name%\requirements_test.txt
	pip install -r %_projects_dir%\%_project_name%\requirements.txt
	pip install -e .
	) ELSE (
	md %_projects_dir%\%_project_name%
	cd %_projects_dir%\%_project_name%
)

IF EXIST %_batch_dir%\venv_%_project_name%_install.bat (
	call %_batch_dir%\venv_%_project_name%_install.bat
) else (
	ECHO @ECHO ON > %_batch_dir%\venv_%_project_name%_install.bat
)

IF EXIST %_batch_dir%\venv_%_project_name%_setup.bat (
	call %_batch_dir%\venv_%_project_name%_setup.bat %_project_name%
	) ELSE (
	ECHO @ECHO ON > %_batch_dir%\venv_%_project_name%_setup.bat
)

