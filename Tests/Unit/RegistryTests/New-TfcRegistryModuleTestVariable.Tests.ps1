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

Describe 'New-TfcRegistryModuleTestVariable' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Key parameter as mandatory' {
            $command = Get-Command New-TfcRegistryModuleTestVariable
            $command.Parameters['Key'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Category parameter as mandatory' {
            $command = Get-Command New-TfcRegistryModuleTestVariable
            $command.Parameters['Category'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with POST' {
            New-TfcRegistryModuleTestVariable -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws' -Key 'test_key' -Category 'terraform'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -like '*/test-module/aws/vars' -and $Method -eq 'POST'
            }
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = New-TfcRegistryModuleTestVariable -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws' -Key 'test_key' -Category 'terraform' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
