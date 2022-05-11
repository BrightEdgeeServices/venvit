@ECHO OFF
CLS
ECHO Initialize "%1" virtual environment
if "%1"=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)
@REM SET %PATH%=C:\Program Files\Python39;C:\Program Files\Python39\Scripts;%PATH%

FOR /D %%y IN (%TEMP%\%_project_name%_*) DO rd /S /Q %%y
FOR /D %%y IN (%TEMP%\temp*) DO rd /S /Q %%y

call d:\venv\%_project_name%_env\Scripts\activate.bat
@ECHO OFF
IF EXIST "d:\Dropbox\Projects\"%_project_name% GOTO ProjectFolder:
GOTO Default:

:ProjectFolder
d:
cd d:\Dropbox\Projects\%_project_name%
GOTO Exit:

:Default
d:
cd d:\Dropbox\Projects
GOTO Exit:

:Exit
call d:\dropbox\batch\venv_%_project_name%_setup.bat %_project_name%
