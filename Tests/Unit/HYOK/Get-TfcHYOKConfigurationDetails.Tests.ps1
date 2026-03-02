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

Describe 'Get-TfcHYOKConfigurationDetails' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have ConfigurationId parameter as mandatory' {
            $command = Get-Command Get-TfcHYOKConfigurationDetails
            $command.Parameters['ConfigurationId'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint' {
            Get-TfcHYOKConfigurationDetails -ConfigurationId 'hyok-abc123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/hyok-configurations/hyok-abc123'
            }
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = Get-TfcHYOKConfigurationDetails -ConfigurationId 'hyok-abc123' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
