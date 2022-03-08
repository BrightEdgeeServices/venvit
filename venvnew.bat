@ECHO OFF
CLS
ECHO Initialize "%1" virtual environment
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
@REM SET %PATH%=C:\Program Files\Python%_python_version%;C:\Program Files\Python%_python_version%\Scripts;%PATH%
call deactivate
"%ProgramFiles%\Python%_python_version%\python" -m venv --clear d:\venv\%_project_name%_env
call d:\venv\%_project_name%_env\Scripts\activate.bat
@REM python.exe -m pip install --upgrade pip
IF EXIST "d:\dropbox\batch\venv_all_venvs_req.txt" (
	pip install -r d:\dropbox\batch\venv_all_venvs_req.txt
)
IF EXIST "d:\Dropbox\Projects\%_project_name%" (
	cd d:\Dropbox\Projects\%_project_name%
	) ELSE (
	md d:\Dropbox\Projects\%_project_name%
	cd d:\Dropbox\Projects\%_project_name%
)
IF EXIST "d:\dropbox\batch\venv_%_project_name%_req.txt" (
	pip install --upgrade -r d:\dropbox\batch\venv_%_project_name%_req.txt
	) ELSE (
	TYPE NUL > "d:\dropbox\batch\venv_%_project_name%_req.txt"
)
IF EXIST "d:\dropbox\batch\venv_%_project_name%_req.bat" (
	call d:\dropbox\batch\venv_%_project_name%_req.bat %_project_name%
	) ELSE (
	ECHO @ECHO ON > "d:\dropbox\batch\venv_%_project_name%_req.bat"
	ECHO pip install -e . >> "d:\dropbox\batch\venv_%_project_name%_req.bat"
)

IF EXIST "d:\dropbox\batch\venv_%_project_name%_setup.bat" (
	call d:\dropbox\batch\venv_%_project_name%_setup.bat %_project_name%
	) ELSE (
	ECHO @ECHO ON > "d:\dropbox\batch\venv_%_project_name%_setup.bat"
)
call d:\dropbox\batch\venvupgrade %_project_name%
