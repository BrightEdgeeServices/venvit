@ECHO OFF
if "%1"=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)

ECHO Upgrade "%_project_name%" virtual environment
call deactivate
call d:\venv\%_project_name%_env\Scripts\activate.bat
d:\venv\%_project_name%_env\scripts\python.exe -m pip install --upgrade pip
IF EXIST "d:\dropbox\batch\venv_all_venvs_req.txt" (
	pip install --upgrade -r d:\dropbox\batch\venv_all_venvs_req.txt
)
IF EXIST "d:\dropbox\batch\venv_%_project_name%_req.txt" (
	pip install --upgrade -r d:\dropbox\batch\venv_%_project_name%_req.txt
)
IF EXIST "d:\dropbox\batch\venv_%_project_name%_req.bat" (
	call d:\dropbox\batch\venv_%_project_name%_req.bat
)
IF EXIST "d:\Dropbox\Projects\%_project_name%" (
	cd d:\Dropbox\Projects\%_project_name%
	) ELSE (
	cd d:\Dropbox\Projects
)
