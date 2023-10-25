# Define a function to handle creating a new virtual environment
function CreateVirtualEnvironment {
    param (
        [string]$_project_name,
        [string]$_python_version,
        [string]$_institution,
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
    if (-not $env:ENVIRONMENT -or -not $env:SCRIPTS_DIR -or -not $env:SECRETS_DIR -or -not $env:PROJECTS_BASE_DIR -or -not $env:VENV_BASE_DIR -or -not $env:VENV_PYTHON_BASE_DIR) {
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
    $_institution = if (-not $_institution) { Read-Host "Issue prefix" } else { $_institution }
    if (-not $_dev_mode -eq "Y" -or -not $_dev_mode -eq "N" -or [string]::IsNullOrWhiteSpace($_dev_mode)) {
        $_dev_mode = ReadYesOrNo -_prompt_text "Dev mode"
    }
    if (-not $_reset -eq "Y" -or -not $_reset -eq "N" -or [string]::IsNullOrWhiteSpace($_reset)) {
        $_reset = ReadYesOrNo -_prompt_text "Reset scripts"
    }

    # Determine project directory based on issue prefix
    switch ($_institution) {
        "PP" { $_institution_dir = Join-Path $_project_base_dir "PP" }
        "RTE" { $_institution_dir = Join-Path $_project_base_dir "RTE" }
        "RE" { $_institution_dir = Join-Path $_project_base_dir "ReahlExamples" }
        "HdT" { $_institution_dir = Join-Path $_project_base_dir "HdT" }
        "DdT" { $_institution_dir = Join-Path $_project_base_dir "DdT" }
        default { $_institution_dir = Join-Path $_project_base_dir "BEE" }
    }
    $_project_dir = Join-Path $_institution_dir $_project_name

    # Output configuration details
    Write-Host "Project name:      $_project_name"
    Write-Host "Python version:    $_python_version"
    Write-Host "Institution Accr:  $_institution"
    Write-Host "Dev Mode:          $_dev_mode"
    Write-Host "Reset project:     $_reset"
    Write-Host "SCRIPTS_DIR:       $_scripts_dir"
    Write-Host "PROJECTS_BASE_DIR: $_project_base_dir"
    Write-Host "INSTITUTION_DIR:   $_institution_dir"
    Write-Host "PROJECT_DIR:       $_project_dir"
    Write-Host "VENV_BASE_DIR:     $_venv_base_dir"
    Write-Host "VENV_PYTHON_BASE:  $_python_base_dir"

    $_continue = ReadYesOrNo -_prompt_text "Continue"
    
    if ($_continue -eq "Y") {
        Set-Location -Path $_institution_dir.Substring(0,2)
        Write-Host $_python_base_dir\Python$_python_version\python -m venv --clear $_venv_base_dir\$_project_name"_env"
        deactivate
        & $_python_base_dir\Python$_python_version\python -m venv --clear $_venv_base_dir\$_project_name"_env"
        & $_venv_base_dir"\"$_project_name"_env\Scripts\activate.ps1"
        python.exe -m pip install --upgrade pip

        if (-not (Test-Path $_project_dir)) {
            New-Item -ItemType Directory -Path "$_project_dir" -Force
            New-Item -ItemType Directory -Path "$_project_dir\docs" -Force
        }

        Set-Location -Path $_project_dir
        if (-not (Test-Path "$_project_dir\docs\requirements_docs.txt")) {
            New-Item -ItemType File -Path "$_project_dir\docs\requirements_docs.txt" -Force
        }
        if (-not (Test-Path "$_project_dir\.pre-commit-config.yaml")) { CreatePreCommitConfigYaml }

        $install_file_name = "venv_${_project_name}_install.ps1"
        $script_install_path = Join-Path -Path $_scripts_dir -ChildPath $install_file_name
        $mandatory_file_name = "venv_${_project_name}_setup_mandatory.ps1"
        $script_mandatory_path = Join-Path $_scripts_dir -ChildPath ${mandatory_file_name}
        if ($_reset -eq "Y") {
            Move-Item -Path $script_install_path -Destination "$_scripts_dir\Archive" -Force
            Move-Item -Path $script_mandatory_path -Destination "$_scripts_dir\Archive" -Force
        }

        # Check if the install script does not exist
        if (-not (Test-Path -Path $script_install_path)) {
            # Create the script and write the lines
            $s = 'Write-Host "Running ' + $install_file_name + '..."'
            Set-Content -Path $script_install_path -Value $s
            Add-Content -Path $script_install_path -Value "git init"
            Add-Content -Path $script_install_path -Value "pip install --upgrade --force black"
            Add-Content -Path $script_install_path -Value "pip install --upgrade --force flake8"
            Add-Content -Path $script_install_path -Value "pip install --upgrade --force pre-commit"
            Add-Content -Path $script_install_path -Value "pre-commit install"
            Add-Content -Path $script_install_path -Value "pre-commit autoupdate"
            if($_dev_mode -eq "Y") {
                Add-Content -Path $script_install_path -Value "if (Test-Path -Path $_project_dir\pyproject.toml) {pip install -e .[dev]}"
                } else {
                    Add-Content -Path $script_install_path -Value "if (Test-Path -Path $_project_dir\pyproject.toml) {pip install -e .}"
            }
        }

        # Check if the mandatory setup script does not exist
        if (-not (Test-Path $script_mandatory_path)) {
            # Create the script and write the lines
            $s = 'Write-Host "Running ' + $mandatory_file_name + '..."'
            Set-Content -Path $script_mandatory_path -Value $s
            Add-Content -Path $script_mandatory_path -Value "`$env:VENV_PY_VER = '$_python_version'"
            Add-Content -Path $script_mandatory_path -Value "`$env:GITIT_ISSUE_PREFIX = '$_institution'"
            Add-Content -Path $script_mandatory_path -Value "`$env:PYTHONPATH = '$_project_dir;$_project_dir\src;$_project_dir\src\$_project_name'"
            Add-Content -Path $script_mandatory_path -Value "`$env:PROJECT_DIR = '$_project_dir'"
            # if ($_init_python_base_dir -eq $true) {
            #     "$env:VENV_PYTHON_BASE = $_python_base_dir"
            # }
        }

        # Check if the custom setup script does not exist
        $custom_file_name = "venv_${_project_name}_setup_custom.ps1"
        $script_custom_path = Join-Path $_scripts_dir -ChildPath ${custom_file_name}
        if (-not (Test-Path $script_custom_path)) {
            $s = 'Write-Host "Running ' + $custom_file_name + '..."'
            Set-Content -Path $script_custom_path -Value $s
        }
        $script_install_path
        $script_mandatory_path
        $script_custom_path
    }
}

function ShowHelp {
    Write-Host 'This script will create a Python virtual environment.  It will use some'
    Write-Host 'environemnt vaiables and some command line parameters to complete the'
    Write-Host 'installation.'
    Write-Host 'If the  pyprject.toml file elready exist in the project directory the python'
    Write-Host 'modules will be installed acordingly.  If _dev_mode = "Y" command line '
    Write-Host 'parameter is "Y", the modules in the [dev] section will also be installed.'
    Write-Host ''
    Write-Host 'Project Linked Powershell Scripts' -ForegroundColor Yellow
    Write-Host 'It will create three more PowerShell scripts.  These scripts are used during'
    Write-Host 'reinstallation and activation of the virtual environment and ar specific to the'
    Write-Host 'project.'
    Write-Host ''
    Write-Host '- venv_' -NoNewline
    Write-Host '$_project_name' -ForegroundColor Red -NoNewline
    Write-Host '_install.ps1'
    Write-Host '  This scrip contains specific installation instructions for this project.'
    Write-Host '  If the script does not exist i.e. when the virtual environment is created for'
    Write-Host '  the first time it will create the script and add default instructions.  You'
    Write-Host '  can alter/add instructions to this script which will be executed during the'
    Write-Host '  next installation.  However, it is not recomended. Rather use the setup_custom'
    Write-Host '  script.'
    Write-Host '  If the script do exist i.e. it is not the first time the virtual environment is'
    Write-Host '  created and/or the _reset parameter is "N", this script will be called.'
    Write-Host '  This script will only be called during installation (vn.ps1) of the virtual'
    Write-Host '  environment.'
    Write-Host '  It will be moved to the Archive sub direcotry and a new one (default) created '
    Write-Host '  if the _reset command line parameter is "Y"'
    Write-Host '  Removing the virtual environment through vr.ps1 will move this script to the Archive'
    Write-Host '  sub direcotry.'
    Write-Host '  '
    Write-Host '- venv_' -NoNewline
    Write-Host '$_project_name' -ForegroundColor Red -NoNewline
    Write-Host '_setup_mandatory.ps1'
    Write-Host '  This script will execute some mandatory instructions for the Bright Edge'
    Write-Host '  development environment.  It is called at the end of the installation (vn.ps1)'
    Write-Host '  and as early as possible during initialization (vi.ps1).  It contains instructions'
    Write-Host '  necessary for successfull initialization.'
    Write-Host '  If the script does not exist i.e. when the virtual environment is created for'
    Write-Host '  the first time it will create the script and add default instructions.  You'
    Write-Host '  can alter/add instructions to this script which will be executed during the'
    Write-Host '  next installation (vn.ps1) and initialization (vi.ps1).  However, it is not'
    Write-Host '  recomended. Rather use the setup_custom script.'
    Write-Host '  If the script does exist i.e. it is not the first time the virtual environment is'
    Write-Host '  created and/or the _reset parameter is "N", this script will be called.'
    Write-Host '  This script will be called during installation (vn.ps1) and initialization (vi.ps1)'
    Write-Host '  of the virtual environment.'
    Write-Host '  This script will be moved to the Archive sub direcotry and a new one (default) created '
    Write-Host '  if the _reset command line parameter is "Y"'
    Write-Host '  Removing the virtual environment through vr.ps1 will move this script to the Archive'
    Write-Host '  sub direcotry.'
    Write-Host '  '
    Write-Host '- venv_' -NoNewline
    Write-Host '$_project_name' -ForegroundColor Red -NoNewline
    Write-Host '_setup_custom.ps1'
    Write-Host '  Use this script to add your own custom configuration instructions for the environment. '
    Write-Host '  It is called at the end of the installation (vn.ps1) and as late as possible during'
    Write-Host '  initialization (vi.ps1).'
    Write-Host '  If the script does not exist i.e. when the virtual environment is created for the'
    Write-Host '  first time it will create the script and add default instructions.  You can alter/add'
    Write-Host '  instructions to this script which will be executed during the next installation (vn.ps1)'
    Write-Host '  and initialization (vi.ps1).  This script is an empty shell on installation.'
    Write-Host '  If the script does exist i.e. it is not the first time the virtual environment is'
    Write-Host '  created, this script will be called.'
    Write-Host '  This script will be called during installation (vn.ps1) and initialization (vi.ps1)'
    Write-Host '  of the virtual environment.'
    Write-Host '  It will be not be moved to the Archive sub direcotry if the _reset command line'
    Write-Host '  parameter is "Y"'
    Write-Host '  Removing the virtual environment through vr.ps1 will move this script to the Archive'
    Write-Host '  sub direcotry.'
    Write-Host '  '
    Write-Host '  * ' -NoNewline
    Write-Host '$_project_name ' -ForegroundColor Red -NoNewline
    Write-Host 'is the first paramater for vn.ps1'
    Write-Host ''
    Write-Host 'Environment Variables' -ForegroundColor Yellow
    Write-Host 'The following enviroment variables must be set i.e. configured as system environment'
    Write-Host 'variables prior to starting the PowerShell.  You can use the "Get-ChildItem Env:"'
    Write-Host 'command in a PowerShell to show the environment variables.'
    Write-Host '- ENVIRONMENT ' -ForegroundColor Red -NoNewline
    Write-Host '= loc_dev'
    Write-Host '  Sets environment i.e. development, github or prod and will call the relevant scripts'
    Write-Host '  to set the secrets for the ewnvironment'
    Write-Host '  c:\Dropbox\Projects\BEE for projects owned by Bright Edge eServices'
    Write-Host '- PROJECTS_BASE_DIR ' -ForegroundColor Red -NoNewline
    Write-Host '= d:\Dropbox\Projects'
    Write-Host '  The directory where all the institutions are created with their projects i.e.'
    Write-Host '  c:\Dropbox\Projects\BEE for projects owned by Bright Edge eServices'
    Write-Host '  c:\Dropbox\Projects\HdT for personal projects'
    Write-Host '  c:\Dropbox\Projects\RTE for RealTime Events projects'
    Write-Host '  etc...'
    Write-Host '- SECRETS_DIR ' -ForegroundColor Red -NoNewline
    Write-Host '= g:\Google Drive\Secrets'
    Write-Host '  A Bright Edge eServices company shared drive where all the secrets are stored for the '
    Write-Host '  company and are used during installation.  Do not store your own personal secretes here.'
    Write-Host '- SCRIPTS_DIR ' -ForegroundColor Red -NoNewline
    Write-Host '= d:\GoogleDrive\Batch'
    Write-Host '  The directory where this script resides.  It should also be in your path.'
    Write-Host '- VENV_BASE_DIR ' -ForegroundColor Red -NoNewline
    Write-Host '= c:\venv'
    Write-Host '  Al the virtual environments will be installed here with a "_env" suffix i.e.'
    Write-Host '  c:\venv\myproject_env.  This dicrecotry should be preferably  not on a cloud storage'
    Write-Host '- VENV_PYTHON_BASE_DIR ' -ForegroundColor Red -NoNewline
    Write-Host '= c:\Python'
    Write-Host '  Install the various versions of Pyton in sub directories i.e. c:\Python\Python39 and'
    Write-Host '  c:\Python\Python310.  These installations will be used to create the virtual environments'
    Write-Host ''
    Write-Host 'usage: vn ProjectName PythonVer Institution DevMode ResetScripts'
    Write-Host 'where'
    Write-Host ' - ProjectName:  The name of the project.'
    Write-Host ' - PythonVer:    The Python version installed in the virtual environment'
    Write-Host ' - Institution:  Accronym of institution ownign the project.'
    Write-Host ' - DevMode:      Install [dev] modules in pyproject.toml'
    Write-Host ' - ResetScripts: Move venv_project_name_setup_mandatory.bat and venv_project_name_install.bat to Archive.'
}

function ShowEnvVarHelp {
    Write-Host "Make sure the following system environment variables are set.  See the help for more detail"
    Write-Host "ENVIRONMENT"
    Write-Host "PROJECTS_BASE_DIR"
    Write-Host "SCRIPTS_DIR"
    Write-Host "SECRETS_DIR"
    Write-Host "VENV_BASE_DIR"
    Write-Host "VENV_PYTHON_BASE_DIR"
}

function CreatePreCommitConfigYaml {
    $pre_commit_file_name = ".pre-commit-config.yaml"
    $pre_commit_path = Join-Path "$_project_dir" -ChildPath $pre_commit_file_name
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

function ReadYesOrNo {
    param (
        [Parameter(Mandatory=$true)]
        [string]$_prompt_text
    )
    do {
        $inputValue = Read-Host "$_prompt_text (Y/n)"
        $inputValue = $inputValue.ToUpper()
        if (-not $inputValue) {
            $inputValue = 'Y'
        }
    } while ($inputValue -ne 'Y' -and $inputValue -ne 'N')
    return $inputValue
}

# Script execution starts here
# You might want to pass parameters in a different way, depending on how you plan to use the script
Write-Host ''
Write-Host ''
Write-Host '=[ START ]====================================================================' -ForegroundColor Blue
Write-Host 'Create a new virtual enviroment' -ForegroundColor Green
CreateVirtualEnvironment -_project_name $args[0] -_python_version $args[1] -_institution $args[2] -_dev_mode $args[3] -_reset $args[4]
Write-Host '-[ END ]----------------------------------------------------------------------' -ForegroundColor Cyan
