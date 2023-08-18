REM Create a new virtual environment
REM The following environment variable must be set
REM - VENV_BASE: The base folder to install the virtual environments' source files. Usually this is a subdirectory
REM              of the project root folder.  In this case we opted for a single directory where the virtual environments
REM              are installed in subdirectories with a "_env" suffix i.e.
REM   /
REM   └── Venv (VENV_BASE)
REM       ├── project1_env
REM       ├── ...
REM       ├── ...
REM       └── project2_env
REM - VENV_BATCH: The directory where this script resides.  This directory must be in your path.
REM - VENV_PYTHON_BASE: The base folder where ethe various versions of Python is installed i.e.
REM   /
REM   └── Python (VENV_PYTHON_BASE)
REM       ├── Python37
REM       ├── Python38
REM       ├── Python39
REM       └── Python310
REM - VENV_PROJECTS: The directory where all your projects are stored in subdirectories.
REM   /
REM   └── Projects (VENV_PROJECTS)
REM       ├── project1
REM       ├── ...
REM       ├── ...
REM       └── project4

REM CLS
@ECHO OFF
IF /I "%5"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
IF "%1"=="" GOTO :AppHelp

@ECHO %_debug%
ECHO Create new %1 virtual environment
ECHO '

set _display_help="N"
IF NOT DEFINED ENVIRONMENT SET _display_help="Y"
IF NOT DEFINED SCRIPTS_DIR SET _display_help="Y"
IF %_display_help%=="Y" GOTO :DisplayEnvVarHelp

IF %ENVIRONMENT%==loc_dev (CALL %SCRIPTS_DIR%\env_var_loc_dev.bat %_debug%)

set _python_base_dir=%VENV_PYTHON_BASE_DIR%
set _venv_base_dir=%VENV_BASE_DIR%
set _scripts_dir=%SCRIPTS_DIR%
set _project_base_dir=%PROJECTS_BASE_DIR%
set _project_name=""
set _python_version=""
set _issue_prefix=""
set _reahl_project=""
set _continue=""
set _init_python_base_dir="N"
set _reset="N"

if %1=="" (
    set /P _project_name="Project name: "
    ) else (
    set _project_name=%1
)
if %2=="" (
    set /P _python_version="Python version: "
    ) else (
    set _python_version=%2
)

if %3=="" (
    set /P _issue_prefix="Issue prefix: "
    ) else (
    set _issue_prefix=%3
)

if %4=="" (
    set /P _reahl_project="Reahl Project (y/N): "
    if %_reahl_project%=="" (set _reahl_project="N")
    ) else (
    set _reahl_project=%4
)
if %6=="" (
    set /P _reset="Reset Project: "
    ) else (
    set _reset=%6
)
set _project_dir=%_project_base_dir%\BEE
if %_issue_prefix%==PP (
    set _project_dir=%_project_base_dir%\PP
) else if %_issue_prefix%==RTE (
    set _project_dir=%_project_base_dir%\RTE
) else if %_issue_prefix%==RE (
    set _project_dir=%_project_base_dir%\ReahlExamples
) else if %_issue_prefix%==HdT (
    set _project_dir=%_project_base_dir%\HdT
)

ECHO Project name:      %_project_name%
ECHO Python version:    %_python_version%
ECHO Issue prefix:      %_issue_prefix%
ECHO Reahl Project:     %_reahl_project%
ECHO Debug:             %_debug%
ECHO Reset project:     %_reset%
ECHO SCRIPTS_DIR:       %_scripts_dir%
ECHO PROJECT_DIR:       %_project_dir%
ECHO PROJECTS_BASE_DIR: %_project_base_dir%
ECHO VENV_BASE_DIR:     %_venv_base_dir%
ECHO VENV_PYTHON_BASE:  %_python_base_dir%


set /P _continue="Continue (Y/n): "
if /I NOT "%_continue%"=="n" (
    set _continue=Y
)

if "%_continue%"=="Y" (
    %_project_dir:~0,2%
    call deactivate
    %_python_base_dir%\Python%_python_version%\python -m venv --clear %_venv_base_dir%\%_project_name%_env

    call %_venv_base_dir%\%_project_name%_env\Scripts\activate.bat
    @ECHO %_debug%
    python.exe -m pip install --upgrade pip

    IF NOT EXIST %_project_dir%\%_project_name% (md %_project_dir%\%_project_name%)
    %_project_dir:~0,2%
    cd %_project_dir%\%_project_name%
    IF NOT EXIST %_project_dir%\%_project_name%\requirements.txt ( ECHO git-it > %_project_dir%\%_project_name%\requirements.txt )
    IF NOT EXIST %_project_dir%\%_project_name%\requirements_test.txt ( ECHO git-it > %_project_dir%\%_project_name%\requirements_test.txt )
    IF NOT EXIST %_project_dir%\%_project_name%\.pre-commit-config.yaml CALL :CreatePreCommitConfigYaml
    pip install --upgrade -r %_project_dir%\%_project_name%\requirements.txt
    pip install --upgrade -r %_project_dir%\%_project_name%\requirements_test.txt

    IF "%_reset%"=="Y" (
        move %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat %_scripts_dir%\Archive
        move %_scripts_dir%\venv_%_project_name%_install.bat %_scripts_dir%\Archive
    )

    IF NOT EXIST %_scripts_dir%\venv_%_project_name%_install.bat (
        ECHO @ECHO %%2 > %_scripts_dir%\venv_%_project_name%_install.bat
        ECHO @ECHO Running venv_%_project_name%_install.bat...>> %_scripts_dir%\venv_%_project_name%_install.bat
        ECHO git init>> %_scripts_dir%\venv_%_project_name%_install.bat
        ECHO pip install --upgrade --force black>> %_scripts_dir%\venv_%_project_name%_install.bat
        ECHO pip install --upgrade --force flake8>> %_scripts_dir%\venv_%_project_name%_install.bat
        ECHO pip install --upgrade --force pre-commit>> %_scripts_dir%\venv_%_project_name%_install.bat
        ECHO pre-commit install>> %_scripts_dir%\venv_%_project_name%_install.bat
        ECHO pre-commit autoupdate>> %_scripts_dir%\venv_%_project_name%_install.bat
        IF /I "%_reahl_project%"=="Y" (
            REM ECHO python -m pip install --upgrade reahl[declarative,sqlite,mysql,dev,doc]>> %_scripts_dir%\venv_%_project_name%_install.bat
            ECHO python -m pip install --upgrade reahl[all]>> %_scripts_dir%\venv_%_project_name%_install.bat
        )
        ECHO IF EXIST "%_project_dir%\%_project_name%\pyproject.toml" pip install -e .>> %_scripts_dir%\venv_%_project_name%_install.bat
    )

    IF NOT EXIST %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat (
        ECHO @ECHO %%2 > %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
        ECHO @ECHO Running venv_%_project_name%_setup_mandatory.bat...>> %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
        ECHO SET VENV_PY_VER=%_python_version%>> %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
        ECHO SET GITIT_ISSUE_PREFIX=%_issue_prefix%>> %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
        ECHO SET PYTHONPATH=%_project_dir%\%_project_name%;%_project_dir%\%_project_name%\src>> %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
        ECHO SET PROJECT_DIR=%_project_dir%\%_project_name%>> %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
        IF %_init_python_base_dir%=="Y" (ECHO SET VENV_PYTHON_BASE=%_python_base_dir%)
        if /I "%_reahl_project%"=="Y" (
            ECHO SET REAHLWORKSPACE=%_project_base_dir%>> %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
            REM ECHO SET MYSQL_PWD=En0l@Gay>> %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
        )
    )

    IF NOT EXIST %_scripts_dir%\Archive\venv_%_project_name%_setup_custom.bat (
        ECHO @ECHO %%2 > %_scripts_dir%\venv_%_project_name%_setup_custom.bat
        ECHO @ECHO Running venv_%_project_name%_setup_custom.bat...>> %_scripts_dir%\venv_%_project_name%_setup_custom.bat
        ) ELSE (
        move %_scripts_dir%\Archive\venv_%_project_name%_setup_custom.bat %_scripts_dir%
    )

    call %_scripts_dir%\venv_%_project_name%_install.bat %_project_name% %_debug%
    call %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat %_project_name% %_debug%
    call %_scripts_dir%\venv_%_project_name%_setup_custom.bat %_project_name% %_debug%
    TYPE %_scripts_dir%\venv_%_project_name%_setup_mandatory.bat
    TYPE %_scripts_dir%\venv_%_project_name%_setup_custom.bat
)
GOTO :Exit

:AppHelp
@ECHO venvnew ProjectName PythonVer GitPrefix Reahl debug
@ECHO where
@ECHO  - ProjectName: The name of the project.
@ECHO  - PythonVer:   The version of Python to use for the virtual environment
@ECHO  - GitPrefix:   The prefix for registering Git issues.
@ECHO  - Reahl:       Is this a Reahl project (Y/N)
@ECHO  - debug:       Display commands (ON/OFF)
@ECHO  - Reset:       Move venv_%_project_name%_setup_mandatory.bat and venv_%_project_name%_install.bat to %_scripts_dir%\Archive (Y/N)
GOTO :Exit

:DisplayEnvVarHelp
@ECHO Define the following environment variables for the current user"
@ECHO ENVIRONMENT: Set current environment variable (loc_dev, rem_dev, qa, prod)
@ECHO SCRIPTS_DIR:  Set the directory path for scripts
GOTO :Exit

:CreatePreCommitConfigYaml
ECHO repos:> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO   - repo: https://github.com/psf/black>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO     rev: stable>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO     hooks:>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO     - id: black>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO       language_version: python3>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO   - repo: https://github.com/pycqa/flake8>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO     rev: stable>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO     hooks:>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO     - id: flake8>> %_project_dir%\%_project_name%\.pre-commit-config.yaml
ECHO       language_version: python3>> %_project_dir%\%_project_name%\.pre-commit-config.yaml

:Exit
EXIT /B 0
