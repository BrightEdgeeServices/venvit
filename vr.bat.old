@ECHO OFF
IF /I "%2"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
@ECHO %_debug%
ECHO Remove %1 virtual environment

REM set _python_base_dir=%VENV_PYTHON_BASE%
REM set _venv_base_dir=%VENV_BASE%
REM set _scripts_dir=%SCRIPTS_DIR%
REM set _projects_dir=%VENV_PROJECTS%

if "%1"=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)


call deactivate
@ECHO %_debug%

move %SCRIPTS_DIR%\venv_%_project_name%_install.bat %SCRIPTS_DIR%\Archive
move %SCRIPTS_DIR%\venv_%_project_name%_setup_mandatory.bat %SCRIPTS_DIR%\Archive
move %SCRIPTS_DIR%\venv_%_project_name%_setup_custom.bat %SCRIPTS_DIR%\Archive

%PROJECTS_BASE_DIR:~0,2%
cd %PROJECTS_BASE_DIR%
rd /S /Q %VENV_BASE_DIR%\%_project_name%_env
