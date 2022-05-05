@ECHO OF
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

call deactivate
"c:\Python\Python%_python_version%\python" -m venv --clear d:\venv\%_project_name%_env
call d:\venv\%_project_name%_env\Scripts\activate.bat

python.exe -m pip install --upgrade pip

IF EXIST "d:\Dropbox\Projects\%_project_name%" (
	cd d:\Dropbox\Projects\%_project_name%
	pip install -r d:\Dropbox\Projects\%_project_name%\requirements.txt
	pip install -r d:\Dropbox\Projects\%_project_name%\requirements_test.txt
	pip install -e .
	) ELSE (
	md d:\Dropbox\Projects\%_project_name%
	cd d:\Dropbox\Projects\%_project_name%
)

IF EXIST "d:\dropbox\batch\venv_%_project_name%_setup.bat" (
	call d:\dropbox\batch\venv_%_project_name%_setup.bat %_project_name%
	) ELSE (
	ECHO @ECHO ON > "d:\dropbox\batch\venv_%_project_name%_setup.bat"
)
@REM call d:\dropbox\batch\venvupgrade %_project_name%
