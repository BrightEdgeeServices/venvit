﻿# Utils.psm1

# TODO
# References to this variable should be replaced through the code with the versioned instances below.
# $defEnvVarSet = @{
#     PROJECTS_BASE_DIR        = @{DefVal = "~\Projects"; IsDir = $true }
#     VENV_BASE_DIR            = @{DefVal = "~\venv"; IsDir = $true }
#     VENV_CONFIG_DEFAULT_DIR  = @{DefVal = "$env:ProgramFiles\VenvIt\Config"; IsDir = $true }
#     VENV_CONFIG_USER_DIR     = @{DefVal = "~\VenvIt\Config"; IsDir = $true }
#     VENV_ENVIRONMENT         = @{DefVal = "loc_dev"; IsDir = $false }
#     VENV_PYTHON_BASE_DIR     = @{DefVal = "c:\Python"; IsDir = $true }
#     VENV_SECRETS_DEFAULT_DIR = @{DefVal = "$env:ProgramFiles\VenvIt\Secrets"; IsDir = $true }
#     VENV_SECRETS_USER_DIR    = @{DefVal = "~\VenvIt\Secrets"; IsDir = $true }
#     VENVIT_DIR               = @{DefVal = "$env:ProgramFiles\VenvIt"; IsDir = $true }
# }

$defEnvVarSet_0_0_0 = @{
    ENVIRONMENT          = @{DefVal = "loc_dev"; IsDir = $false }
    RTE_ENVIRONMENT      = @{DefVal = "loc_dev"; IsDir = $false }
    SCRIPTS_DIR          = @{DefVal = "D:\Batch"; IsDir = $true }
    SECRETS_DIR          = @{DefVal = "D:\Batch"; IsDir = $true }
    VENV_BASE_DIR        = @{DefVal = "d:\venv"; IsDir = $true }
    VENV_PYTHON_BASE_DIR = @{DefVal = "c:\Python"; IsDir = $true }
}
$defEnvVarSet_6_0_0 = @{
    PROJECT_NAME           = @{DefVal = $null; IsDir = $false }
    PROJECTS_BASE_DIR      = @{DefVal = "~\Projects"; IsDir = $true }
    VENV_BASE_DIR          = @{DefVal = "~\venv"; IsDir = $true }
    VENV_CONFIG_DIR        = @{DefVal = "$env:ProgramFiles\VenvIt\Config"; IsDir = $true }
    VENV_ENVIRONMENT       = @{DefVal = "loc_dev"; IsDir = $false }
    VENV_ORGANIZATION_NAME = @{DefVal = $null; IsDir = $false }
    VENV_PYTHON_BASE_DIR   = @{DefVal = "c:\Python"; IsDir = $true }
    VENV_SECRETS_DIR       = @{DefVal = "$env:ProgramFiles\VenvIt\Secrets"; IsDir = $true }
    VENVIT_DIR             = @{DefVal = "$env:ProgramFiles\VenvIt"; IsDir = $true }
    VIRTUAL_ENV            = @{DefVal = $null; IsDir = $false }
}
$defEnvVarSet_7_0_0 = @{
    PROJECT_NAME             = @{DefVal = $null; IsDir = $false; SystemMandatory = $false }
    PROJECTS_BASE_DIR        = @{DefVal = "~\Projects"; IsDir = $true; SystemMandatory = $true }
    VENV_BASE_DIR            = @{DefVal = "~\venv"; IsDir = $true; SystemMandatory = $true }
    VENV_CONFIG_DEFAULT_DIR  = @{DefVal = "$env:ProgramFiles\VenvIt\Config"; IsDir = $true; SystemMandatory = $true }
    VENV_CONFIG_USER_DIR     = @{DefVal = "~\VenvIt\Config"; IsDir = $true; SystemMandatory = $true }
    VENV_ENVIRONMENT         = @{DefVal = "loc_dev"; IsDir = $false; SystemMandatory = $true }
    VENV_ORGANIZATION_NAME   = @{DefVal = $null; IsDir = $false; SystemMandatory = $false }
    VENV_PYTHON_BASE_DIR     = @{DefVal = "c:\Python"; IsDir = $true; SystemMandatory = $true }
    VENV_SECRETS_DEFAULT_DIR = @{DefVal = "$env:ProgramFiles\VenvIt\Secrets"; IsDir = $true; SystemMandatory = $true }
    VENV_SECRETS_USER_DIR    = @{DefVal = "~\VenvIt\Secrets"; IsDir = $true; SystemMandatory = $true }
    VENVIT_DIR               = @{DefVal = "$env:ProgramFiles\VenvIt"; IsDir = $true; SystemMandatory = $true }
    VIRTUAL_ENV              = @{DefVal = $null; IsDir = $false; SystemMandatory = $false }
}
$x = @{ a = @{aa = "11" }; b = @{bb = "22" } }

$separator = "-" * 80

function Backup-ArchiveOldVersion {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [String]$InstallationDir,

        [Parameter(Mandatory = $true, Position = 1)]
        [String]$TimeStamp,

        [Parameter(Mandatory = $false, Position = 2)]
        [String]$DestinationDir = $null
    )

    $fileList = $null
    # $destination = $null
    $archiveVersion = Get-Version -SourceDir $InstallationDir
    # Write-Host $archiveVersion
    if ($archiveVersion -eq "0.0.0") {
        $fileList = $env:SCRIPTS_DIR
    }
    elseif ($archiveVersion -eq "6.0.0") {
        $fileList = $env:VENVIT_DIR, $env:VENV_CONFIG_DIR, $env:VENV_SECRETS_DIR
    }
    elseif ($archiveVersion -eq "7.0.0") {
        $fileList = $env:VENVIT_DIR, $env:VENV_CONFIG_DEFAULT_DIR, $env:VENV_CONFIG_USER_DIR, $env:VENV_SECRETS_DEFAULT_DIR, $env:VENV_SECRETS_USER_DIR
    }

    if ($fileList) {
        if (-not $DestinationDir) {
            $DestinationDir = Join-Path -Path $InstallationDir -ChildPath "Archive"
        }
        if (-not(Test-Path $DestinationDir)) {
            New-Item -Path $DestinationDir -ItemType Directory | Out-Null
        }
        $destinationPath = Join-Path -Path $DestinationDir -Child ("VEnvIt_$archiveVersion" + "_" + "$TimeStamp.zip")
        $compress = @{
            Path             = $fileList
            CompressionLevel = "Fastest"
            DestinationPath  = $destinationPath
        }
        Compress-Archive @compress | Out-Null
    }

    return $DestinationPath
}

function Backup-ScriptToArchiveIfExists {
    param (
        [string]$SourcePath,
        [string]$ArchiveDir,
        [string]$TimeStamp
    )

    # Check if the file exists
    if (Test-Path $SourcePath) {
        # Ensure the archive directory exists
        if (-not (Test-Path $ArchiveDir)) {
            New-Item -Path $ArchiveDir -ItemType Directory
        }
        $archivePath = Join-Path -Path $ArchiveDir -ChildPath ($env:PROJECT_NAME + "_" + $TimeStamp + ".zip")
        if (Test-Path $archivePath) {
            Compress-Archive -Path $SourcePath -Update -DestinationPath $archivePath
        }
        else {
            Compress-Archive -Path $SourcePath -DestinationPath $archivePath
        }
        # Write-Host "Zipped $ScriptPath."
    }
    return $archivePath
}

function Confirm-SystemEnvironmentVariablesExist {
    param (
        $Set
    )
    # Check for required environment variables and display help if they're missing
    $Result = @()

    foreach ($var in $Set.Keys) {
        if ($Set[$var]["SystemMandatory"]) {
            if (-not (Get-Item env:$var -ErrorAction SilentlyContinue)) {
                $Result += $var
            }
        }
    }
    return $Result
}

function Copy-Deep($object) {
    # For complex objects that require deep copying (copying nested structures), you can use serialization:
    $serialized = [System.Management.Automation.PSSerializer]::Serialize($object)
    return [System.Management.Automation.PSSerializer]::Deserialize($serialized)
}

function Get-ConfigFileName {
    param(
        [string]$ProjectName,
        [string]$Postfix
    )
    return ("VEnv" + $ProjectName + "$Postfix.ps1")
}

function Get-ManifestFileName {
    return "Manifest.psd1"
}

function Get-SecretsFileName {
    return "Secrets.ps1"
}
function Get-Version {
    param (
        [Parameter(Mandatory = $true)]
        [String]$SourceDir
    )
    $version = $null
    if (Test-Path $SourceDir) {
        $manifestPath = Join-Path -Path $SourceDir -ChildPath (Get-ManifestFileName)
        if (Test-Path $manifestPath) {
            $Manifest = Import-PowerShellDataFile -Path $manifestPath
            $version = [version]$Manifest.ModuleVersion
        }
        elseif (Test-Path "env:VENVIT_DIR") {
            $version = "6.0.0"
        }
        elseif (Test-Path "env:SCRIPTS_DIR") {
            $version = "0.0.0"
        }
    }
    return $version
}

function New-CustomTempDir {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Prefix
    )
    $TempDir = Join-Path -Path $env:TEMP -ChildPath ($Prefix + "_" + [Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $TempDir | Out-Null
    return $TempDir
}

function Invoke-Script {
    param (
        [string]$Script
    )
    # Write-Host $Script
    & $Script
}

function Get-ReadAndSetEnvironmentVariables {
    param(
        $EnvVarSet
    )

    foreach ($envVar in $EnvVarSet.Keys) {
        $existingValue = [System.Environment]::GetEnvironmentVariable($envVar, [System.EnvironmentVariableTarget]::Machine)
        if ($existingValue) {
            $promptText = $envVar + " ($existingValue)"
            $defaultValue = $existingValue
        }
        else {
            $promptText = $envVar + " (" + $EnvVarSet[$envVar]["DefVal"] + ")"
            $defaultValue = $EnvVarSet[$envVar]["DefVal"]
        }
        $newValue = Read-Host -Prompt $promptText
        if ($newValue -eq "") {
            $newValue = $defaultValue
        }
        Set-Item -Path env:$envVar -Value $newValue
        [System.Environment]::SetEnvironmentVariable($envVar, $newValue, [System.EnvironmentVariableTarget]::Machine)
    }
}

function Show-EnvironmentVariables {
    Write-Host ""
    Write-Host "System Environment Variables" -ForegroundColor Green
    Write-Host "VENV_ENVIRONMENT:         $env:VENV_ENVIRONMENT"
    Write-Host "PROJECTS_BASE_DIR:        $env:PROJECTS_BASE_DIR"
    Write-Host "PROJECT_DIR:              $env:PROJECT_DIR"
    Write-Host "VENVIT_DIR:               $env:VENVIT_DIR"
    Write-Host "VENV_SECRETS_DEFAULT_DIR: $env:VENV_SECRETS_DIR"
    Write-Host "VENV_SECRETS_USER_DIR:    $env:VENV_SECRETS_DIR"
    Write-Host "VENV_CONFIG_DIR:          $env:VENV_CONFIG_DIR"
    Write-Host "VENV_BASE_DIR:            $env:VENV_BASE_DIR"
    Write-Host "VENV_PYTHON_BASE_DIR:     $env:VENV_PYTHON_BASE_DIR"
    Write-Host ""
    Write-Host "Project Environment Variables" -ForegroundColor Green
    Write-Host "PROJECT_NAME:             $env:PROJECT_NAME"
    Write-Host "VENV_ORGANIZATION_NAME:   $env:VENV_ORGANIZATION_NAME"
    Write-Host "INSTALLER_PWD:            $env:INSTALLER_PWD"
    Write-Host "INSTALLER_USERID:         $env:INSTALLER_USERID"
    Write-Host "MYSQL_DATABASE:           $env:MYSQL_DATABASE"
    Write-Host "MYSQL_HOST:               $env:MYSQL_HOST"
    Write-Host "MYSQL_ROOT_PASSWORD:      $env:MYSQL_ROOT_PASSWORD"
    Write-Host "MYSQL_TCP_PORT:           $env:MYSQL_TCP_PORT"
    Write-Host ""
    Write-Host "Git Information" -ForegroundColor Green
    git branch --all
}

function Read-YesOrNo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PromptText
    )
    do {
        $inputValue = Read-Host "$PromptText (Y/n)"
        $inputValue = $inputValue.ToUpper()
        if (-not $inputValue) {
            $inputValue = "Y"
        }
        $PromptText = "Only Y or N"
    } while ($inputValue -ne 'Y' -and $inputValue -ne 'N')
    if ($inputValue -eq "Y") {
        $Result = $true
    }
    else {
        $Result = $false
    }

    return $Result
}

function Publish-EnvironmentVariables {
    param(
        [Object]$EnvVarSet
    )
    foreach ($envVar in $EnvVarSet.Keys) {
        $newValue = $EnvVarSet[$envVar]["DefVal"]
        Set-Item -Path env:$envVar -Value $newValue
        [System.Environment]::SetEnvironmentVariable($envVar, $newValue, [System.EnvironmentVariableTarget]::Machine)
    }
}

function Unpublish-EnvironmentVariables {
    param(
        [Object]$EnvVarSet
    )
    foreach ($envVar in $EnvVarSet.Keys) {
        Set-Item -Path env:$envVar -Value $null
        [System.Environment]::SetEnvironmentVariable($envVar, $null, [System.EnvironmentVariableTarget]::Machine)
    }
}

Export-ModuleMember -Variable defEnvVarSet_7_0_0, separator, x
Export-ModuleMember -Function Backup-ArchiveOldVersion, Backup-ScriptToArchiveIfExists, Confirm-SystemEnvironmentVariablesExist, Copy-Deep
Export-ModuleMember -Function Get-ReadAndSetEnvironmentVariables, Get-ConfigFileName, Get-ManifestFileName, Get-SecretsFileName
Export-ModuleMember -Function Get-Version, Invoke-Script, New-CustomTempDir, Publish-EnvironmentVariables, Read-YesOrNo
Export-ModuleMember -Function Show-EnvironmentVariables, Unpublish-EnvironmentVariables