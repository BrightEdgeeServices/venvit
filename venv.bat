@ECHO ON
CLS
@ECHO Initialize "%1" virtual environment

IF /I "%2"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)

IF %ENVIRONMENT%==loc_dev CALL %SCRIPTS_DIR%\env_var_loc_dev.bat %_debug%

set _venv_base_dir=d:\venv
set _batch_dir=d:\dropbox\batch
set _projects_dir=d:\Dropbox\Projects

if "%1"=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)

FOR /D %%y IN (%TEMP%\%_project_name%_*) DO rd /S /Q %%y
FOR /D %%y IN (%TEMP%\temp*) DO rd /S /Q %%y

call %_venv_base_dir%\%_project_name%_env\Scripts\deactivate.bat
call %_venv_base_dir%\%_project_name%_env\Scripts\activate.bat
@ECHO On
IF EXIST %_projects_dir%\%_project_name% GOTO ProjectFolder:
GOTO Default:

:ProjectFolder
d:
cd %_projects_dir%\%_project_name%
call %_batch_dir%\venv_%_project_name%_setup.bat %_project_name%
GOTO Exit:

:Default
d:
cd %_projects_dir%
GOTO Exit:

:Exit
call %_batch_dir%\venv_%_project_name%_setup.bat %_project_name%
