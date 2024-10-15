﻿Describe "Function testing" {
    Context "Invoke-Install Function Tests" {
        BeforeAll {
            . $PSScriptRoot\..\src\Install.ps1 -Pester
            $moduleName = "Conclude-Install"
            # Remove the module if it's already loaded
            if (Get-Module -Name $moduleName) {
                Remove-Module -Name $moduleName
            }

            Import-Module "$PSScriptRoot\..\src\Utils.psm1"
            Import-Module "$PSScriptRoot\..\src\Conclude-Install.psm1"

            $MockTag = "1.0.0"
            $TempBaseDir = New-CustomTempDir -Prefix "venvit"
            $OrigVenvIiDir = $env:VENVIT_DIR
            $OrigVenvSecretsDir = $env:VENV_SECRETS_DIR
            $env:VENVIT_DIR = "$TempBaseDir\VENVIT_DIR"
            $env:VENV_SECRETS_DIR = "$TempBaseDir\VENV_SECRETS_DIR"
            New-Item -ItemType Directory -Path $env:VENVIT_DIR -Force -ErrorAction SilentlyContinue
            New-Item -ItemType Directory -Path $env:VENV_SECRETS_DIR -Force -ErrorAction SilentlyContinue
        }

        It "Shoulsd Invoke-ConcludeInstall" {
            Mock Set-ExecutionPolicy {}
            Mock Invoke-WebRequest {
                return @"
                    [{"tag_name": "$MockTag"}]
"@
            } -ParameterFilter { $Uri -eq "https://api.github.com/repos/BrightEdgeeServices/venvit/releases" }
            Mock Invoke-WebRequest {
                Copy-Item -Path $PSScriptRoot\..\src\Conclude-Install.psm1 -Destination $OutFile -Verbose
            } -ParameterFilter { $Uri -eq "https://github.com/BrightEdgeeServices/venvit/releases/download/$MockTag/Conclude-Install.psm1" }
            Mock Import-Module {
                Import-Module "$PSScriptRoot\..\src\Conclude-Install.psm1"
            } -ParameterFilter { $Name.StartsWith($env:TEMP)}
            # Mock -ModuleName Conclude-Install -CommandName Invoke-ConcludeInstall {
            Mock Invoke-ConcludeInstall {
                "exit" | Out-File -FilePath "$env:VENVIT_DIR\vn.ps1" -Force
                "exit" | Out-File -FilePath "$env:VENVIT_DIR\vi.ps1" -Force
                "exit" | Out-File -FilePath "$env:VENVIT_DIR\vr.ps1" -Force
                "exit" | Out-File -FilePath "$env:VENV_SECRETS_DIR\dev_env_var.ps1" -Force
            }

            Invoke-Install

            Assert-MockCalled -CommandName "Invoke-WebRequest" -Exactly 2
            Assert-MockCalled -CommandName "Invoke-ConcludeInstall" -Exactly 1
        }

        AfterAll {
            $env:VENVIT_DIR = $OrigVenvItDir
            $env:VENV_SECRETS_DIR = $OrigVenvSecretsDir
        }
    }
    Context "Show-Help Function Tests" {
        # Test to be implemented
    }
}

Describe "Install.ps1 testing" {
    # Test to be implemented
}

