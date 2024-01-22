function CleanUpCache
{
    param (
        [string]$_project_name
    )
    $_dirs_to_delete = @(
        ".pytest_cache",
        "__pycache__",
        "build",
        "$_project_name.egg-info"
        "desktop.ini"
    )
    foreach ($_dir in $_dirs_to_delete) {
        $_items = Get-ChildItem -Path . -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $_dir }
        foreach ($_item in $_items) {
            if (Test-Path $_item.FullName) {
                if ($_item.PSIsContainer) {
                    Remove-Item -Path $_item.FullName -Recurse -Force
                } else {
                    Remove-Item -Path $_item.FullName -Force
                }
                $_full_name = $_item.FullName
                Write-Host "Delete: $_item - $_full_name"
            }
        }
            }
}


function ShowHelp {
    $separator = "-" * 80
    Write-Host $separator -ForegroundColor Cyan

    # Introduction
@"
This script clean and remove up all the cache files in teh current and sub directories.

Note:
1. Be carefull.  If will delete the directories in all sub directories and can have severe consequences.
"@ | Write-Host

    Write-Host $separator -ForegroundColor Cyan

@"
    Usage:
    ------
    ./initdb.ps1 ProjectName
    ./initdb.ps1 -h

    Parameters:
    ProjectName: The name of the project.  Enables the finding of *.egg-info directories
    -h: Show this help

"@ | Write-Host

}

# Script execution starts here
Write-Host ''
Write-Host ''
$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "=[ START $dateTime ]==================================================" -ForegroundColor Blue
# Show help if no project name is provided
if ($args[0] -eq "-h" -or $args[0] -eq "") {
    ShowHelp
} else {
    CleanUpCache -_project_name $args[0]
}
$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "-[ END $dateTime ]==================================================" -ForegroundColor Cyan
Write-Host ''
Write-Host ''
