Clear-Host
Write-Host "Initialize `"$($args[0])`" virtual environment"

if ($args[1] -eq "ON") {
    $_debug = "ON"
} else {
    $_debug = "OFF"
}
Write-Host $_debug

if ($args[0] -eq $null) {
    $_project_name = Read-Host -Prompt "Project name"
} else {
    $_project_name = $args[0]
}

if ($env:ENVIRONMENT -eq "loc_dev") {
    & "$env:SCRIPTS_DIR\env_var_loc_dev.bat" $_debug
}
& "$env:VENV_BASE_DIR\$($_project_name)_env\Scripts\deactivate.bat"
Write-Host $_debug
& "$env:VENV_BASE_DIR\$($_project_name)_env\Scripts\activate.bat"
Write-Host $_debug
& "$env:SCRIPTS_DIR\venv_$($_project_name)_setup_mandatory.bat" $_project_name $_debug

Get-ChildItem -Path "$env:TEMP\$($_project_name)_*" -Directory | Remove-Item -Recurse -Force
Get-ChildItem -Path "$env:TEMP\temp*" -Directory | Remove-Item -Recurse -Force

if (Test-Path $env:PROJECT_DIR) {
    Set-Location -Path $env:PROJECT_DIR
} else {
    Set-Location -Path $env:VENV_PYTHON_BASE_DIR
}

& "$env:SCRIPTS_DIR\venv_$($_project_name)_setup_custom.bat" $_project_name $_debug
