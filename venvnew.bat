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
copy d:\projects\Templates\pip.ini %_venv_base_dir%\%_project_name%_env
call %_venv_base_dir%\%_project_name%_env\Scripts\activate.bat

IF EXIST "%_batch_base_dir%\venv_all_venvs_req.txt" (
	pip install -r %_batch_dir%\venv_all_venvs_req.txt
)

d:
IF EXIST "%_projects_dir%\%_project_name%" (
	cd %_projects_dir%\%_project_name%
	) ELSE (
	md %_projects_dir%\%_project_name%
	cd %_projects_dir%\%_project_name%
)

IF EXIST "%_batch_dir%\venv_%_project_name%_req.txt" (
	pip install --upgrade -r %_batch_dir%\venv_%_project_name%_req.txt
	) ELSE (
	TYPE NUL > "%_batch_dir%\venv_%_project_name%_req.txt"
)

IF EXIST "%_batch_dir%\venv_%_project_name%_req.bat" (
	call %_batch_dir%\venv_%_project_name%_req.bat %_project_name% %_python_base_dir%\Python%_python_version%
	) ELSE (
	ECHO @ECHO ON > "%_batch_dir%\venv_%_project_name%_req.bat"
	ECHO pip install -e . >> "%_batch_dir%\venv_%_project_name%_req.bat"
)


IF EXIST "%_batch_dir%\venv_%_project_name%_setup.bat" (
	call %_batch_dir%\venv_%_project_name%_setup.bat %_project_name%
	) ELSE (
	ECHO @ECHO ON > "%_batch_dir%\venv_%_project_name%_setup.bat"
)

call %_batch_dir%\venvupgrade %_project_name%
