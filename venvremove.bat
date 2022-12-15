@ECHO OFF
IF /I "%2"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
@ECHO %_debug%
ECHO Remove %1 virtual environment

set _python_base_dir=%VENV_PYTHON_BASE%
set _venv_base_dir=%VENV_BASE%
set _scripts_dir=%SCRIPTS_DIR%
set _projects_dir=%VENV_PROJECTS%

if "%1"=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)


call deactivate
@ECHO %_debug%
d:
cd %_projects_dir%
rd /S /Q %_venv_base_dir%\%_project_name%_env
REM del /Q %_scripts_dir%\venv_%_project_name%_setup.bat %_scripts_dir%\venv_%_project_name%_install.bat
