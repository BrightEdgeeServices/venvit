@echo off

REM Deactivate Python virtual environment if currently in one
deactivate >nul 2>&1

REM Check if the PROJECTS_BASE_DIR environment variable exists and change directory
if not defined PROJECTS_BASE_DIR (
    echo The PROJECTS_BASE_DIR environment variable is not set
    exit /b
)

cd /d "%PROJECTS_BASE_DIR%" || exit /b

REM Check if 3 arguments are provided
if "%~3"=="" (
    echo Please execute the command with the following parameters:
    echo - Project Name
    echo - Add plop templates ^(y/n^)
    echo - Project type ^(Expo/PRN^)
    exit /b
)

REM Check if the second argument is "y" or "n"
if /i "%~2" neq "y" if /i "%~2" neq "n" (
    echo Please execute the command with the following parameters:
    echo - Project Name
    echo - Add plop templates ^(y/n^)
    echo - Project type ^(Expo/PRN^)
    exit /b
)

REM Check if the third argument is "Expo" or "PRN"
if /i "%~3" neq "Expo" if /i "%~3" neq "PRN" (
    echo Please execute the command with the following parameters:
    echo - Project Name
    echo - Add plop templates ^(y/n^)
    echo - Project type ^(Expo/PRN^)
    exit /b
)

REM Assign argument values to variables
set "project_name=%~1"
set "add_plop=%~2"
set "project_type=%~3"

REM Run "expo init" or "react-native init" with the provided project name and select the appropriate template option based on the project type
if /i "%project_type%"=="Expo" (
    call npx create-expo-app "%project_name%" --template blank
) else (
    call npx react-native init "%project_name%"
)

cd "%project_name%"

REM Create the "src" directory in the newly created project
mkdir "src"

REM Create additional directories inside the "src" directory
mkdir "src\components"
mkdir "src\screens"
mkdir "src\styles"
mkdir "src\api"
mkdir "src\hooks"
mkdir "src\context"

REM If the user input is "y", copy the plop templates
if /i "%add_plop%"=="y" (
    call addplop.bat
)

echo Done

exit /b
