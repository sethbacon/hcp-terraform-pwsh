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

Describe 'Get-TfcRegistryModuleTestRun' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            $command = Get-Command Get-TfcRegistryModuleTestRun
            $command.Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have ModuleName parameter as mandatory' {
            $command = Get-Command Get-TfcRegistryModuleTestRun
            $command.Parameters['ModuleName'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint' {
            Get-TfcRegistryModuleTestRun -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -like '*/tests/registry-modules/private/test-org/test-module/aws/test-runs'
            }
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = Get-TfcRegistryModuleTestRun -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
