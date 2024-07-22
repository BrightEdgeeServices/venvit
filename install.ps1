param (
    [string]$release
)

function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole($adminRole)
}

# Check for administrative privileges
if (-not (Test-Admin)) {
    Write-Host "This script needs to be run as an administrator. Please run it in an elevated PowerShell session." -ForegroundColor Red
    exit
}

# Define the URL for downloading the zip file
$url = "https://github.com/BrightEdgeeServices/venvit/releases/download/$release/installation_files.zip"

# Define the path for the downloaded zip file
$zipFilePath = "installation_files.zip"

# Download the zip file
Write-Host "Downloading installation files from $url..."
Invoke-WebRequest -Uri $url -OutFile $zipFilePath

# Function to get or prompt for an environment variable
function Get-Or-PromptEnvVar {
    param (
        [string]$varName,
        [string]$promptText
    )
    $existingValue = [System.Environment]::GetEnvironmentVariable($varName, [System.EnvironmentVariableTarget]::Machine)
    if ($existingValue) {
        Write-Host "$varName is already set to $existingValue"
        return $existingValue
    } else {
        $newValue = Read-Host $promptText
        [System.Environment]::SetEnvironmentVariable($varName, $newValue, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "$varName set to $newValue"
        return $newValue
    }
}

# Acquire user input for environment variables if they are not already set
$VENV_ENVIRONMENT = Get-Or-PromptEnvVar -varName "VENV_ENVIRONMENT" -promptText "Enter value for VENV_ENVIRONMENT"
$PROJECTS_BASE_DIR = Get-Or-PromptEnvVar -varName "PROJECTS_BASE_DIR" -promptText "Enter value for PROJECTS_BASE_DIR"
$VENVIT_DIR = Get-Or-PromptEnvVar -varName "VENVIT_DIR" -promptText "Enter value for VENVIT_DIR"
$SECRETS_DIR = Get-Or-PromptEnvVar -varName "SECRETS_DIR" -promptText "Enter value for SECRETS_DIR"
$VENV_BASE_DIR = Get-Or-PromptEnvVar -varName "VENV_BASE_DIR" -promptText "Enter value for VENV_BASE_DIR"
$VENV_PYTHON_BASE_DIR = Get-Or-PromptEnvVar -varName "VENV_PYTHON_BASE_DIR" -promptText "Enter value for VENV_PYTHON_BASE_DIR"

# Ensure the VENVIT_DIR and SECRETS_DIR directories exist
if (-not (Test-Path -Path $VENVIT_DIR)) {
    New-Item -ItemType Directory -Path $VENVIT_DIR | Out-Null
}
if (-not (Test-Path -Path $SECRETS_DIR)) {
    New-Item -ItemType Directory -Path $SECRETS_DIR | Out-Null
}

# Unzip the file in the VENVIT_DIR directory, overwriting any existing files
Write-Host "Unzipping installation_files.zip to $VENVIT_DIR..."
Expand-Archive -Path $zipFilePath -DestinationPath $VENVIT_DIR -Force

# Move the env_var_dev.ps1 file from VENVIT_DIR to SECRETS_DIR if it does not already exist in SECRETS_DIR
$sourceFilePath = Join-Path -Path $VENVIT_DIR -ChildPath "env_var_dev.ps1"
$destinationFilePath = Join-Path -Path $SECRETS_DIR -ChildPath "env_var_dev.ps1"

if (Test-Path -Path $sourceFilePath) {
    if (-not (Test-Path -Path $destinationFilePath)) {
        Write-Host "Moving env_var_dev.ps1 to $SECRETS_DIR..."
        Move-Item -Path $sourceFilePath -Destination $destinationFilePath -Force
    } else {
        Write-Host "env_var_dev.ps1 already exists in $SECRETS_DIR. It will not be overwritten."
    }
} else {
    Write-Host "env_var_dev.ps1 not found in $VENVIT_DIR."
}

# Remove the zip file after extraction
Remove-Item -Path $zipFilePath -Force
Write-Host "installation_files.zip has been deleted."

# Add VENVIT_DIR to the System Path variable
$path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
if ($path -notlike "*$VENVIT_DIR*") {
    $newPath = "$path;$VENVIT_DIR"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
    Write-Host "VENVIT_DIR has been added to the System Path."
} else {
    Write-Host "VENVIT_DIR is already in the System Path."
}

Write-Host "Environment variables have been set successfully."

# Confirmation message
Write-Host "Installation and configuration are complete."

# Remove the install.ps1 script
$scriptPath = $MyInvocation.MyCommand.Path
Write-Host "Removing the install.ps1 script..."
Remove-Item -Path $scriptPath -Force
Write-Host "install.ps1 has been deleted."
