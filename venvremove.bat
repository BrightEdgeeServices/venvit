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

move %_scripts_dir%\venv_%_project_name%_install.bat %_scripts_dir%\Archive
move %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat %_scripts_dir%\Archive
move %_scripts_dir%\venv_%_project_name%_setup_custom.bat %_scripts_dir%\Archive

%_projects_dir:~0,2%
cd %_projects_dir%
rd /S /Q %_venv_base_dir%\%_project_name%_env
