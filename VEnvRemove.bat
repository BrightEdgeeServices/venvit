@ECHO OFF
if "%1"=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)

@ECHO Remove "%_project_name%" virtual environment
call deactivate
d:
cd d:\dropbox\projects
rd /S /Q d:\venv\%_project_name%_env
