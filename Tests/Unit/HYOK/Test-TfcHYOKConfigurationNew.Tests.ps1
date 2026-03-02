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

Describe 'Test-TfcHYOKConfigurationNew' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            $command = Get-Command Test-TfcHYOKConfigurationNew
            $command.Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have KeyProviderId parameter as mandatory' {
            $command = Get-Command Test-TfcHYOKConfigurationNew
            $command.Parameters['KeyProviderId'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with POST' {
            Test-TfcHYOKConfigurationNew -Organization 'test-org' -KeyProviderId 'kp-123' -KeyName 'my-key'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/organizations/test-org/hyok-configurations/test' -and $Method -eq 'POST'
            }
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = Test-TfcHYOKConfigurationNew -Organization 'test-org' -KeyProviderId 'kp-123' -KeyName 'my-key' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
