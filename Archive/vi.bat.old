@ECHO OFF
CLS
@ECHO Initialize "%1" virtual environment

IF /I "%2"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
@ECHO %_debug%

@ECHO %_debug%
if "%1"=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)
IF %ENVIRONMENT%==loc_dev CALL "%SECRETS_DIR%\env_var_dev.bat" %_project_name% %_debug%
) else if %ENVIRONMENT%==github_dev (
    set _project_dir="%_project_base_dir%\%GITIT_ISSUE_PREFIX%"
call %VENV_BASE_DIR%\%_project_name%_env\Scripts\deactivate.bat
@ECHO %_debug%
call %VENV_BASE_DIR%\%_project_name%_env\Scripts\activate.bat
@ECHO %_debug%
call %SCRIPTS_DIR%\venv_%_project_name%_setup_mandatory.bat %_project_name% %_debug%
REM set _project_base_dir=%PROJECTS_BASE%


FOR /D %%y IN (%TEMP%\%_project_name%_*) DO rd /S /Q %%y
FOR /D %%y IN (%TEMP%\temp*) DO rd /S /Q %%y

IF EXIST %PROJECT_DIR% GOTO ProjectFolder:
GOTO Default:

:ProjectFolder
%PROJECT_DIR:~0,2%
cd %PROJECT_DIR%
GOTO Exit:

:Default
%VENV_PYTHON_BASE_DIR:~0,2%
cd %VENV_PYTHON_BASE_DIR%
GOTO Exit:

:Exit
call %SCRIPTS_DIR%\venv_%_project_name%_setup_custom.bat %_project_name% %_debug%
