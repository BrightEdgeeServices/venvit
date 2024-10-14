﻿# param (
#     # Base directory of configs
#     [Parameter(Mandatory = $false, Position = 0)]
#     [string]$ConfigBaseDir,

#     # Invoke the help.  This parameter will render above positional parameters inconsequential.
#     [Parameter(Mandatory = $false)]
#     [Switch]$Help,

#     # Used to indicate that the code is called by Pester to avoid unwanted code execution during Pester testing.
#     [Parameter(Mandatory = $false)]
#     [Switch]$Pester
# )
function Convert-PyprojectToml {
    param (
        [string]$filePath
    )

    $content = Get-Content -Path $filePath

    $version = $null
    $authors = @()
    $description = $null
    $isAuthorsBlock = $false

    foreach ($line in $content) {
        # Extract version
        if ($line -match "^version\s*=\s*['""](.+?)['""]") {
            $version = $matches[1]
        }
        # Extract description
        elseif ($line -match "^description\s*=\s*['""](.+?)['""]") {
            $description = $matches[1]
        }
        # Start of authors block
        elseif ($line -match "^authors\s*=\s*\[") {
            $isAuthorsBlock = $true
        }
        # End of authors block
        elseif ($isAuthorsBlock -and $line -match "\]") {
            $isAuthorsBlock = $false
        }
        # Inside authors block, clean up and add authors
        elseif ($isAuthorsBlock) {
            $cleanedAuthor = $line.Trim().Trim("'", ' ', ',')  # Remove quotes and extra characters
            if ($cleanedAuthor -ne "") {
                $authors += $cleanedAuthor
            }
        }
    }

    # Combine authors into a single string with a comma and space
    $authorString = $authors -join ", "

    return @{
        Version     = $version
        Authors     = $authorString
        Description = $description
    }
}

function Invoke-UpdateManifest {
    param (
        [string]$ConfigBaseDir  # Root directory parameter
    )

    # Construct the paths for pyproject.toml and manifest.psd1 based on the provided directory
    $pyprojectPath = Join-Path -Path $ConfigBaseDir -ChildPath "pyproject.toml"
    $manifestPath = Join-Path -Path $ConfigBaseDir -ChildPath "Manifest.psd1"

    # Check if pyproject.toml exists
    if (Test-Path -Path $pyprojectPath) {
        # Extract data from pyproject.toml
        $pyprojectData = Convert-PyprojectToml -filePath $pyprojectPath

        # Check if all necessary data was extracted
        if ($pyprojectData.Version -and $pyprojectData.Authors -and $pyprojectData.Description) {
            # Create the manifest.psd1
            New-ManifestPsd1 -filePath $manifestPath -data $pyprojectData
            Write-Host "Manifest.psd1 created successfully at $manifestPath"
        }
        else {
            Write-Host "Failed to extract required fields from pyproject.toml"
        }
    }
    else {
        Write-Host "pyproject.toml not found at $pyprojectPath"
    }
}

function New-ManifestPsd1 {
    param (
        [string]$FilePath,
        [hashtable]$data
    )

    $content = @"
@{
    ModuleVersion = '$($data.Version)'
    Author        = '$($data.Authors)'
    Description   = '$($data.Description)'
}
"@

    Set-Content -Path $FilePath -Value $content
}

# function Show-Help {
#     $separator = "-" * 80
#     Write-Host $separator -ForegroundColor Cyan

#     # Introduction
#     @"
# Update the manifest for the project from the pyproject.toml files.
# "@ | Write-Host
#     Write-Host $separator -ForegroundColor Cyan
#     @"
#     Usage:
#     ------
#     Update-Manifest.ps1 ConfigBaseDir
#     Update-Manifest.ps1 -h | --help

#     where:
#       ConfigBaseDir:  Location of the pyproject.toml configuration file.
# "@ | Write-Host
# }

# Script execution starts here
# Pester parameter is to ensure that the script does not execute when called from
# pester BeforeAll.  Any better ideas would be welcome.
# if (-not $Pester) {
#     Write-Host ''
#     Write-Host ''
#     $dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#     Write-Host "=[ START $dateTime ]=========================[ Update-Manifest.ps1 ]=" -ForegroundColor Blue
#     Write-Host "Update manifest" -ForegroundColor Blue
#     # The script should not run if it is invoked by Pester
#     # if ($args.Count -eq 0 -or $args[0] -eq "-h" -or $args[0] -eq "--help") {
#     if ($ConfigBaseDir -eq "" -or $Help) {
#         Show-Help
#     }
#     else {
#             Invoke-UpdateManifest -ConfigBaseDir $args[0]
#     }
#     Write-Host '-[ END ]------------------------------------------------------------------------' -ForegroundColor Cyan
#     Write-Host ''
#     Write-Host ''
# }