function DisplayEnvironmentVariables {
    Write-Host ""
    Write-Host "Set by System"  -ForegroundColor Green
    Write-Host "ENVIRONMENT = $env:ENVIRONMENT"
    Write-Host "PROJECTS_BASE_DIR = $env:PROJECTS_BASE_DIR"
    Write-Host "SCRIPTS_DIR = $env:SCRIPTS_DIR"
    Write-Host "SECRETS_DIR = $env:SECRETS_DIR"
    Write-Host "VENV_BASE_DIR = $env:VENV_BASE_DIR"
    Write-Host "VENV_PYTHON_BASE_DIR = $env:VENV_PYTHON_BASE_DIR"
    Write-Host ""
    Write-Host "Set by current environment"  -ForegroundColor Green
    Write-Host "INSTALLER_PWD = $env:INSTALLER_PWD"
    Write-Host "INSTALLER_USERID = $env:INSTALLER_USERID"
    Write-Host "MYSQL_ROOT_PASSWORD = $env:MYSQL_ROOT_PASSWORD"
}
function InitVirtualEnvironment {
    param (
        [string]$_project_name
    )
    # Show help if no project name is provided
    if (-not $_project_name -or $_project_name -eq "-h") {
        ShowHelp
        return
    }

    Write-Host "Initialize the  $_project_name virtual environment"

    # Check for required environment variables and display help if they're missing
    if (-not $env:ENVIRONMENT -or -not $env:SCRIPTS_DIR -or -not $env:SECRETS_DIR -or -not $env:PROJECTS_BASE_DIR -or -not $env:VENV_BASE_DIR) {
        ShowEnvVarHelp
        return
    }
    # Set local variables from environment variables
    $_project_base_dir = $env:PROJECTS_BASE_DIR
    $_scripts_dir = $env:SCRIPTS_DIR
    $_secrets_dir = $env:SECRETS_DIR
    $_venv_base_dir = $env:VENV_BASE_DIR
    $_venv_dir = "$_venv_base_dir\${_project_name}_env"

    if ($env:ENVIRONMENT -eq "loc_dev") {
        & "$_secrets_dir\env_var_dev.ps1"
    }

    deactivate
    & "$_venv_dir\Scripts\activate.ps1"
    & "${_scripts_dir}\venv_${_project_name}_setup_mandatory.ps1" $_project_name
    $_project_dir = $env:PROJECT_DIR

    # Remove temporary directories from previous sessions
    Get-ChildItem -Path $env:TEMP -Directory -Filter "$_project_name`_*" | Remove-Item -Recurse -Force
    Get-ChildItem -Path $env:TEMP -Directory -Filter "temp*" | Remove-Item -Recurse -Force

    if (Test-Path $_project_dir) {
        Set-Location -Path $_project_dir.Substring(0,2)
        Set-Location -Path $_project_dir
    } else {
        Set-Location -Path $_project_base_dir.Substring(0,2)
        Set-Location -Path $_project_base_dir
    }   

    & "${_scripts_dir}\venv_${_project_name}_setup_custom.ps1" $_project_name
}

function ShowEnvVarHelp {
    Write-Host "Make sure the following system environment variables are set. See the help for more detail." -ForegroundColor Cyan

    $_env_vars = @(
        @("ENVIRONMENT", $env:ENVIRONMENT),
        @("PROJECTS_BASE_DIR", "$env:PROJECTS_BASE_DIR"),
        @("SCRIPTS_DIR", "$env:SCRIPTS_DIR"),
        @("SECRETS_DIR", "$env:SECRETS_DIR"),
        @("VENV_BASE_DIR", "$env:VENV_BASE_DIR")
    )

    foreach ($var in $_env_vars) {
        if ([string]::IsNullOrEmpty($var[1])) {
            Write-Host $var[0] -ForegroundColor Red -NoNewline
            Write-Host " - Not Set"
        } else {
            Write-Host $var[0] -ForegroundColor Green -NoNewline
            $s = " - Set to: " +  $var[1]
            Write-Host $s
        }
    }
}

function ShowHelp {
    $separator = "-" * 80
    Write-Host $separator -ForegroundColor Cyan
    
    # Introduction
@"
This script, 'vi.ps1', initializes a Python virtual environment. This include running the 
venv_${_project_name}_setup_custom .ps1 and venv_${_project_name}_setup_mandatory.ps1 scripts.
"@ | Write-Host

    Write-Host $separator -ForegroundColor Cyan

    # Environment Variables
@"
    Environment Variables:
    ----------------------
    Prior to starting the PowerShell script, ensure these environment variables are set.

    1. ENVIRONMENT:       Sets the development environment. Possible values: loc_dev, github_dev, prod, etc.
    2. PROJECTS_BASE_DIR: The directory for all projects (e.g., d:\Dropbox\Projects).
    3. SECRETS_DIR:       Directory for storing secrets (e.g., g:\Google Drive\Secrets).
    4. SCRIPTS_DIR:       Directory where this script resides.
    5. VENV_BASE_DIR:     Directory for virtual environments (e.g., c:\venv).
"@ | Write-Host
Write-Host $separator -ForegroundColor Cyan
@"
    Usage:
    ------
    vi.ps1 ProjectName 
    vi.ps1 -h

    Parameters:
    1. ProjectName:  The name of the project.
"@ | Write-Host

}

function ShowEnvVarHelp {
    Write-Host "Make sure the following system environment variables are set. See the help for more detail." -ForegroundColor Cyan

    $_env_vars = @(
        @("ENVIRONMENT", $env:ENVIRONMENT),
        @("PROJECTS_BASE_DIR", "$env:PROJECTS_BASE_DIR"),
        @("SCRIPTS_DIR", "$env:SCRIPTS_DIR"),
        @("SECRETS_DIR", "$env:SECRETS_DIR"),
        @("VENV_BASE_DIR", "$env:VENV_BASE_DIR")
    )

    foreach ($var in $_env_vars) {
        if ([string]::IsNullOrEmpty($var[1])) {
            Write-Host $var[0] -ForegroundColor Red -NoNewline
            Write-Host " - Not Set"
        } else {
            Write-Host $var[0] -ForegroundColor Green -NoNewline
            $s = " - Set to: " +  $var[1]
            Write-Host $s
        }
    }
}

# Script execution starts here
Write-Host ''
Write-Host ''
$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "=[ START $dateTime ]==================================================" -ForegroundColor Blue
InitVirtualEnvironment -_project_name $args[0]
DisplayEnvironmentVariables
Write-Host '-[ END ]------------------------------------------------------------------------' -ForegroundColor Cyan
Write-Host ''
Write-Host ''
