BeforeAll {
    $helpersPath = Join-Path $PSScriptRoot '..' '..' 'Helpers' 'TestHelpers.psm1'
    Import-Module $helpersPath -Force
    $mocksPath = Join-Path $PSScriptRoot '..' '..' 'Mocks' 'TfcMocks.psm1'
    Import-Module $mocksPath -Force
    $modulePath = Join-Path $PSScriptRoot '..' '..' '..' 'Output' 'TerraformCloud' 'TerraformCloud.psd1'
    Import-Module $modulePath -Force
    $env:TFE_TOKEN = "test-token-12345"
}

AfterAll {
    Remove-Module TerraformCloud -Force -ErrorAction SilentlyContinue
    Remove-Module TestHelpers -Force -ErrorAction SilentlyContinue
    Remove-Module TfcMocks -Force -ErrorAction SilentlyContinue
}

Describe 'Update-TfcGPGKey' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have RegistryName parameter as mandatory' {
            $command = Get-Command Update-TfcGPGKey
            $command.Parameters['RegistryName'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have NewNamespace parameter as mandatory' {
            $command = Get-Command Update-TfcGPGKey
            $command.Parameters['NewNamespace'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with PATCH' {
            Update-TfcGPGKey -RegistryName 'private' -Namespace 'test-namespace' -KeyId 'key-123' -NewNamespace 'new-namespace'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -like '*/api/registry/private/v2/gpg-keys/test-namespace/key-123*' -and $Method -eq 'PATCH'
            }
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = Update-TfcGPGKey -RegistryName 'private' -Namespace 'test-namespace' -KeyId 'key-123' -NewNamespace 'new-namespace' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
