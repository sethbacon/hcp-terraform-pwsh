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

Describe 'Save-TfcConfigurationVersion' {
    BeforeEach { Mock Invoke-WebRequest -ModuleName TerraformCloud }

    Context 'Parameter Validation' {
        It 'Should have ConfigurationVersionId parameter as mandatory' {
            (Get-Command Save-TfcConfigurationVersion).Parameters['ConfigurationVersionId'].Attributes.Mandatory | Should -Be $true
        }
        It 'Should have OutputPath parameter as mandatory' {
            (Get-Command Save-TfcConfigurationVersion).Parameters['OutputPath'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = Save-TfcConfigurationVersion -ConfigurationVersionId 'cv-abc123' -OutputPath '/tmp/test.tar.gz' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
