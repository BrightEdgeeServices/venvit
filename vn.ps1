# Define a function to handle creating a new virtual environment
function CreateVirtualEnvironment {
    param (
        [string]$_project_name,
        [string]$_python_version,
        [string]$_issue_prefix,
        [string]$_dev_mode,
        [string]$_reset
    )

    # Clear the screen
    # Clear-Host

    # Show help if no project name is provided
    if (-not $_project_name) {
        ShowHelp
        return
    }

    Write-Host "Create new $_project_name virtual environment"

    # Check for required environment variables and display help if they're missing
    if (-not $env:ENVIRONMENT -or -not $env:SCRIPTS_DIR -or -not $env:SECRETS_DIR) {
        ShowEnvVarHelp
        return
    }

    if ($env:ENVIRONMENT -eq "loc_dev") {
        & "$env:SECRETS_DIR\env_var_dev.ps1"
    }

    # Set local variables from environment variables
    $_python_base_dir = $env:VENV_PYTHON_BASE_DIR
    $_venv_base_dir = $env:VENV_BASE_DIR
    $_scripts_dir = $env:SCRIPTS_DIR
    $_project_base_dir = $env:PROJECTS_BASE_DIR
    $_project_name = if (-not $_project_name) { Read-Host "Project name" } else { $_project_name }
    $_python_version = if (-not $_python_version) { Read-Host "Python version" } else { $_python_version }
    $_issue_prefix = if (-not $_issue_prefix) { Read-Host "Issue prefix" } else { $_issue_prefix }
    $_dev_mode = if (-not $_dev_mode) {
        $_input = Read-Host "Install in dev env (Y/n)"
        if (-not $_input) { "Y" } else { $_input }
    } else {
        $_dev_mode
    }
    $_reset = if (-not $_reset) { Read-Host "Reset Project" } else { $_reset }

    # Determine project directory based on issue prefix
    switch ($_issue_prefix) {
        "PP" { $_project_dir = Join-Path $_project_base_dir "PP" }
        "RTE" { $_project_dir = Join-Path $_project_base_dir "RTE" }
        "RE" { $_project_dir = Join-Path $_project_base_dir "ReahlExamples" }
        "HdT" { $_project_dir = Join-Path $_project_base_dir "HdT" }
        "DdT" { $_project_dir = Join-Path $_project_base_dir "DdT" }
        default { $_project_dir = Join-Path $_project_base_dir "BEE" }
    }

    # Output configuration details
    Write-Host "Project name:      $_project_name"
    Write-Host "Python version:    $_python_version"
    Write-Host "Issue prefix:      $_issue_prefix"
    Write-Host "Dev Mode:          $_dev_mode"
    Write-Host "Reset project:     $_reset"
    Write-Host "SCRIPTS_DIR:       $_scripts_dir"
    Write-Host "PROJECT_DIR:       $_project_dir"
    Write-Host "PROJECTS_BASE_DIR: $_project_base_dir"
    Write-Host "VENV_BASE_DIR:     $_venv_base_dir"
    Write-Host "VENV_PYTHON_BASE:  $_python_base_dir"

    $_continue = Read-Host "Continue (Y/n)"
    if ($_continue -ne "n") {
        $_continue = "Y"
    }

    if ($_continue -eq "Y") {
        Set-Location -Path $_project_dir.Substring(0,2)
        Write-Host $_python_base_dir\Python$_python_version\python -m venv --clear $_venv_base_dir\$_project_name"_env"
        deactivate
        & $_python_base_dir\Python$_python_version\python -m venv --clear $_venv_base_dir\$_project_name"_env"
        & $_venv_base_dir"\"$_project_name"_env\Scripts\activate.ps1"
        python.exe -m pip install --upgrade pip

        if (-not (Test-Path $_project_dir"\"$_project_name)) {
            New-Item -ItemType Directory -Path "$_project_dir\$_project_name" -Force
            New-Item -ItemType Directory -Path "${_project_dir}\${_project_name}\docs" -Force
        }

        Set-Location -Path $_project_dir
        if (-not (Test-Path "$_project_dir\$_project_name\docs\requirements_docs.txt")) {
            New-Item -ItemType File -Path "$_project_dir\$_project_name\docs\requirements_docs.txt" -Force
        }
        if (-not (Test-Path "$_project_dir\$_project_name\.pre-commit-config.yaml")) { CreatePreCommitConfigYaml }

        if ($_reset -eq "Y") {
            Move-Item -Path $_scripts_dir"\venv"_$_project_name"_setup_mandatory.bat" -Destination "$_scripts_dir\Archive" -Force
            Move-Item -Path $_scripts_dir"\venv"_$_project_name"_setup_mandatory.bat" -Destination "$_scripts_dir\Archive" -Force
        }

        # Check if the install script does not exist
        $install_file_name = "venv_${_project_name}_install.ps1"
        $script_install_path = Join-Path -Path $_scripts_dir -ChildPath $install_file_name
        if (-not (Test-Path -Path $script_install_path)) {
            # Create the script and write the lines
            Set-Content -Path $script_install_path -Value "Running ${install_file_name}..."
            Add-Content -Path $script_install_path -Value "git init"
            Add-Content -Path $script_install_path -Value "pip install --upgrade --force black"
            Add-Content -Path $script_install_path -Value "pip install --upgrade --force flake8"
            Add-Content -Path $script_install_path -Value "pip install --upgrade --force pre-commit"
            Add-Content -Path $script_install_path -Value "pre-commit install"
            Add-Content -Path $script_install_path -Value "pre-commit autoupdate"
            if($_dev_mode -eq "Y") {
                Add-Content -Path $script_install_path -Value "if (Test-Path -Path $_project_dir\$_project_name\pyproject.toml) {pip install -e .[dev]}"
                } else {
                    Add-Content -Path $script_install_path -Value "if (Test-Path -Path $_project_dir\$_project_name\pyproject.toml) {pip install -e .}"
            }
        }

        # Check if the mandatory setup script does not exist
        $mandatory_file_name = "venv_${_project_name}_setup_mandatory.ps1"
        $script_mandatory_path = Join-Path $_scripts_dir -ChildPath ${mandatory_file_name}
        if (-not (Test-Path $script_mandatory_path)) {
            Set-Content -Path $script_mandatory_path -Value "Running $mandatory_file_name..."
            Add-Content -Path $script_mandatory_path -Value "`$env:VENV_PY_VER = '$_python_version'"
            Add-Content -Path $script_mandatory_path -Value "`$env:GITIT_ISSUE_PREFIX = '$_issue_prefix'",
            Add-Content -Path $script_mandatory_path -Value "`$env:PYTHONPATH = '$_project_dir\$_project_name;$_project_dir\$_project_name\src;$_project_dir\$_project_name\src\$_project_name'",
            Add-Content -Path $script_mandatory_path -Value "`$env:PROJECT_DIR = '$_project_dir\$_project_name"
            if ($_init_python_base_dir -eq $true) {
                "$env:VENV_PYTHON_BASE = $_python_base_dir"
            }
        }

        # Check if the custom setup script does not exist
        $custom_file_name = "venv_${_project_name}_setup_custom.ps1"
        $script_custom_path = Join-Path $_scripts_dir -ChildPath ${custom_file_name}
        if (-not (Test-Path $script_custom_path)) {
            Set-Content -Path $script_custom_path -Value "Write-Host Running $custom_file_name..."
        }
        $script_install_path
        $script_mandatory_path
        $script_custom_path
    }
}

function ShowHelp {
    Write-Host "venvnew _project_name PythonVer GitPrefix Reahl debug"
    Write-Host "where"
    Write-Host " - Project Name:   The name of the project."
    Write-Host " - Python Ver:     The version of Python to use for the virtual environment"
    Write-Host " - Git Prefix:     The prefix for registering Git issues."
    Write-Host " - Dev Mode (Y/n): Is this a Reahl project (Y/N)"
    Write-Host " - Reset scripts:  Move venv_$_project_name_setup_mandatory.bat and venv_$_project_name_install.bat to $_scripts_dir\Archive (Y/N)"
}

function ShowEnvVarHelp {
    Write-Host "Define the following environment variables for the current user`nENVIRONMENT: Set current environment variable (loc_dev, rem_dev, qa, prod)"
    Write-Host "ENVIRONMENT: Set current environment variable (loc_dev, rem_dev, qa, prod)"
    Write-Host "SCRIPTS_DIR: Set the directory path for scripts"
    Write-Host "SECRETS_DIR: Set the directory where the environment variables are stored with the secrets"
}

function CreatePreCommitConfigYaml {
    $pre_commit_file_name = ".pre-commit-config.yaml"
    $pre_commit_path = Join-Path "${_project_dir}\${_project_name}" -ChildPath ${pre_commit_file_name}
    Set-Content -Path $pre_commit_path -Value "repos:"
    Add-Content -Path $pre_commit_path -Value "  - repo: https://github.com/psf/black"
    Add-Content -Path $pre_commit_path -Value "    rev: stable"
    Add-Content -Path $pre_commit_path -Value "    hooks:"
    Add-Content -Path $pre_commit_path -Value "    - id: black"
    Add-Content -Path $pre_commit_path -Value "      language_version: python3"
    Add-Content -Path $pre_commit_path -Value "  - repo: https://github.com/pycqa/flake8"
    Add-Content -Path $pre_commit_path -Value "    rev: stable"
    Add-Content -Path $pre_commit_path -Value "    hooks:"
    Add-Content -Path $pre_commit_path -Value "    - id: flake8"
    Add-Content -Path $pre_commit_path -Value "      language_version: python3"
}

# Script execution starts here
# You might want to pass parameters in a different way, depending on how you plan to use the script
CreateVirtualEnvironment -_project_name $args[0] -_python_version $args[1] -_issue_prefix $args[2] -_dev_mode $args[3] -_reset $args[4]
