# Turn off the echoing of commands
# $InformationPreference = 'SilentlyContinue'

Write-Output "Remove $($args[0]) virtual environment"

# Uncomment the following lines if you want to use these environment variables
# $_python_base_dir = $env:VENV_PYTHON_BASE
# $_venv_base_dir = $env:VENV_BASE
# $_scripts_dir = $env:SCRIPTS_DIR
# $_projects_dir = $env:VENV_PROJECTS

# Check if the first argument is empty and ask for user input if it is
if ([string]::IsNullOrEmpty($args[0])) {
    $_project_name = Read-Host "Project name"
} else {
    $_project_name = $args[0]
}

# Deactivate the current virtual environment if it is active
deactivate

# Construct the paths based on the script directory and project name
$script_path = Join-Path $env:SCRIPTS_DIR "venv_${_project_name}_install.ps1"
$mandatory_path = Join-Path $env:SCRIPTS_DIR "venv_${_project_name}_setup_mandatory.ps1"
$custom_path = Join-Path $env:SCRIPTS_DIR "venv_${_project_name}_setup_custom.ps1"
$archive_dir = Join-Path $env:SCRIPTS_DIR "Archive"

# Move the files to the archive directory
Move-Item $script_path $archive_dir -ErrorAction SilentlyContinue -Force
Move-Item $mandatory_path $archive_dir -ErrorAction SilentlyContinue -Force
Move-Item $custom_path $archive_dir -ErrorAction SilentlyContinue -Force
Move-Item $custom_path $archive_dir -ErrorAction SilentlyContinue -Force

# Navigate to the projects base directory and remove the specified directory
Set-Location $env:PROJECTS_BASE_DIR
Remove-Item "${env:VENV_BASE_DIR}\${_project_name}_env" -Recurse -Force -ErrorAction SilentlyContinue
