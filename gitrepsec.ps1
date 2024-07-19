git remote set-url origin https://hendrikdutoit:$GH_REPO_ACCESS_BY_OWN_APPS@github.com/BrightEdgeeServices/$PROJECT_NAME.git

function CreateVirtualEnvironment {
    param (
        [string]$_organization,
        [string]$_username
    )
    # Show help if no project name is provided
    if (-not $_organization -or $_project_name -eq "-h") {
        ShowHelp
        return
    }

    # Check for required environment variables and display help if they're missing
    if (-not $env:GH_REPO_ACCESS_BY_OWN_APPS -or -not $env:PROJECT_NAME ) {
        ShowEnvVarHelp
        return
    }

    # Determine expanded organization
    switch ($_organization) {
        "BEE" { $_organization = "BrightEdgeeServices" }
        "BrightEdgeeServices" { $_organization = "BrightEdgeeServices" }
        "Citiq" { $_organization = "citiq-prepaid" }
        "HdT" { $_organization = "hendrikdutoit" }
        "hendrikdutoit" { $_organization = "hendrikdutoit" }
        "RTE" { $_organization = "RealTimeEvents" }
        "RealTimeEvents" { $_organization = "RealTimeEvents" }
        default { $_organization =  "hendrikdutoit" }
    }
    $cmd = "git remote add origin https://${_username}:$env:GH_REPO_ACCESS_BY_OWN_APPS@github.com/${_organization}/$env:PROJECT_NAME.git"
    Write-Host $cmd
    & $cmd
    $cmd = "git remote set-url origin https://${_username}:$env:GH_REPO_ACCESS_BY_OWN_APPS@github.com/${_organization}/$env:PROJECT_NAME.git"
    Write-Host $cmd
    & $cmd
}

function DisplayEnvironmentVariables {
    Write-Host ""
    Write-Host "System Environment Variables"  -ForegroundColor Green
    Write-Host "GH_REPO_ACCESS_BY_OWN_APPS: $env:GH_REPO_ACCESS_BY_OWN_APPS"
    Write-Host "PROJECT_NAME:               $env:PROJECT_NAME"
    Write-Host ""
    Write-Host "Git Information"  -ForegroundColor Green
    git branch --all
}

function ShowEnvVarHelp {
    Write-Host "Make sure the following system environment variables are set. See the help for more detail." -ForegroundColor Cyan

    $_env_vars = @(
        @("GH_REPO_ACCESS_BY_OWN_APPS", $env:GH_REPO_ACCESS_BY_OWN_APPS),
        @("PROJECT_NAME", "$env:PROJECT_NAME")
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
This script, 'gitrepsec.ps1', configure the credentials for the projec to be able to
push the project to GitHub
"@ | Write-Host

    Write-Host $separator -ForegroundColor Cyan

    # Environment Variables
@"
    Environment Variables:
    ----------------------
    Prior to starting the PowerShell script, ensure these environment variables are set.

    1. GH_REPO_ACCESS_BY_OWN_APPS: Your GitHub token.
    2. PROJECT_NAME:               Repository Name of the project.
"@ | Write-Host

    Write-Host $separator -ForegroundColor Cyan

    # Usage
@"
    Usage:
    ------
    vn.ps1 Organization UserName
    vr.ps1 -h

    Parameters:
    1. Organization: The name of the organization ir user name the repository belongs to.
    2. UserName:     User name to access the repository.
"@ | Write-Host

    Write-Host $separator -ForegroundColor Cyan
}

# Script execution starts here
Write-Host ''
Write-Host ''
Write-Host "Set GitHub credentials"
$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "=[ START $dateTime ]==================================================" -ForegroundColor Blue
CreateVirtualEnvironment -_organization $args[0] -_username $args[1]
DisplayEnvironmentVariables
Write-Host '-[ END ]------------------------------------------------------------------------' -ForegroundColor Cyan
