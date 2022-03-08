@ECHO OFF
CLS
if "%1"=="" (
    set /P _project_name="Project name:: "
    ) else (
    set _project_name=%1
)
reahl dropdb etc -y
pip uninstall -y %_project_name%
