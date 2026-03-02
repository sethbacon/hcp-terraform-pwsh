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

Describe 'Get-TfcRegistryModuleTestVariable' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            $command = Get-Command Get-TfcRegistryModuleTestVariable
            $command.Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint' {
            Get-TfcRegistryModuleTestVariable -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -like '*/test-module/aws/vars'
            }
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = Get-TfcRegistryModuleTestVariable -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
