@echo on

REM Check if currently in a Python virtual environment and deactivate if necessary
deactivate >nul 2>&1

REM Get the value of the PROJECTS_BASE_DIR environment variable
set "projects_base_dir=%PROJECTS_BASE_DIR%"

REM Check if the PROJECTS_BASE_DIR environment variable is set
if "%projects_base_dir%"=="" (
    echo The PROJECTS_BASE_DIR environment variable is not set
    exit /b
)

REM Change directory to the PROJECTS_BASE_DIR
cd /d "%projects_base_dir%"

REM Check if the project name is provided as the first argument
if "%~1"=="" (
    set /p project_name=What will the name of the project be? 
) else (
    set project_name=%~1
)

REM Check if the project directory already exists
if exist "%project_name%" (
    echo This project already exists
    exit /b
)

REM Check if the second argument is provided
if "%~2"=="" (
    set /p "add_plop=Please state whether you would like to add plop templates? (y/n): "
) else (
    set add_plop=%~2
)

REM Check if expo-cli is installed and get the version
for /f "tokens=*" %%I in ('npm show expo-cli version --silent') do set "latest_version=%%I"

REM Define the desired version
for /f "delims=" %%A in ('expo --version') do set "current_version=%%A"

REM Compare the desired version with the latest version
if "%current_version%" neq "%latest_version%" (
    echo Installing the latest version of expo-cli...
    call npm install -g expo-cli@latest
) else (
    echo expo-cli is already up to date
)

REM Run "expo init" with the provided project name and select the first template option
call npx expo-cli init "%project_name%" --template blank

cd %project_name%

REM Create the "src" directory in the newly created project
mkdir "src"

REM Create additional directories inside the "src" directory
mkdir "src\Components"
mkdir "src\Screens"
mkdir "src\Styles"

REM If the user input is "y", copy the plop templates
if /i "%add_plop%"=="y" (
	call addplop.bat
)

echo Done

exit /b
