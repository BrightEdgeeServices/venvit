# Clear the screen
# Clear-Host
Write-Output "Initialize `"$($args[0])`" virtual environment"

# Read project name if not supplied
if ([string]::IsNullOrEmpty($args[0])) {
    $_project_name = Read-Host "Project name"
} else {
    $_project_name = $args[0]
}

if ($env:ENVIRONMENT -eq "loc_dev") {
    & "$env:SECRETS_DIR\env_var_dev.ps1" $_project_name
} elseif ($env:ENVIRONMENT -eq "github_dev") {
    # This statement has to be corrected
    $_project_dir = "$env:_project_base_dir\$env:GITIT_ISSUE_PREFIX"
}
deactivate
& "$env:VENV_BASE_DIR\${_project_name}_env\Scripts\activate.ps1"
$_scripts_dir = $env:SCRIPTS_DIR
& "${_scripts_dir}\venv_${_project_name}_setup_mandatory.ps1" $_project_name
$_project_dir = $env:PROJECT_DIR

# Remove specified directories
Get-ChildItem -Path $env:TEMP -Directory -Filter "$_project_name`_*" | Remove-Item -Recurse -Force
Get-ChildItem -Path $env:TEMP -Directory -Filter "temp*" | Remove-Item -Recurse -Force

if (Test-Path $_project_dir) {
    Set-Location -Path $_project_dir.Substring(0,2)
    Set-Location -Path $_project_dir
} else {
    Set-Location -Path $env:VENV_PYTHON_BASE_DIR.Substring(0,2)
    Set-Location -Path $env:VENV_PYTHON_BASE_DIR
}

& "${_scripts_dir}\venv_${_project_name}_setup_custom.ps1" $_project_name
