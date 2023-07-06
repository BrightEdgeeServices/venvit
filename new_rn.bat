@echo off

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
    set /p "project_name=What will the name of the project be? "
) else (
    set "project_name=%~1"
)

REM Check if the project directory already exists
if exist "%project_name%" (
    echo This project already exists
    exit /b
)

REM Check if the second argument is provided and validate it as "y" or "n"
if "%~2"=="" (
    :prompt_add_plop
    set /p "add_plop=Please state whether you would like to add plop templates? (y/n): "
    if /i "%add_plop%"=="y" (
        set "add_plop=y"
        goto :continue
    ) else (
        if /i "%add_plop%"=="n" (
            set "add_plop=n"
            goto :continue
        ) else (
            echo Invalid input. Please enter "y" or "n".
            goto :prompt_add_plop
        )
    )
) else (
    :validate_add_plop
    if /i "%~2%"=="y" (
        set "add_plop=y"
    ) else (
        if /i "%~2%"=="n" (
            set "add_plop=n"
        ) else (
            echo Invalid input. Please enter "y" or "n".
            exit /b
        )
    )
)

:continue

REM Check if the third argument is provided and validate it as "Expo" or "PRN"
if "%~3"=="" (
    :prompt_project_type
    set /p "project_type=Which type of project do you want? (Expo/Pure React Native (PRN)): "
    if /i "%project_type%"=="Expo" (
        set "project_type=Expo"
        goto :continue_project_type
    ) else (
        if /i "%project_type%"=="PRN" (
            set "project_type=PRN"
            goto :continue_project_type
        ) else (
            echo Invalid input. Please enter "Expo" or "PRN".
            exit /b
        )
    )
) else (
    :validate_project_type
    if /i "%~3%"=="Expo" (
        set "project_type=Expo"
    ) else (
        if /i "%~3%"=="PRN" (
            set "project_type=PRN"
        ) else (
            echo Invalid input. Please enter "Expo" or "PRN".
            exit /b
        )
    )
)

:continue_project_type

call npx install expo

REM Run "expo init" or "react-native init" with the provided project name and select the appropriate template option based on the project type
if /i "%project_type%"=="Expo" (
    call npx create-expo-app "%project_name%" --template blank
) else (
    call npx react-native init "%project_name%"
)

cd %project_name%

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
