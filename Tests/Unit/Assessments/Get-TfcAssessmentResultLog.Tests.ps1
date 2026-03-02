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
Describe 'Get-TfcAssessmentResultLog' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }
    Context 'Parameter Validation' {
        It 'Should have AssessmentResultId parameter as mandatory' {
            (Get-Command Get-TfcAssessmentResultLog).Parameters['AssessmentResultId'].Attributes.Mandatory | Should -Be $true
        }
    }
    Context 'API Interaction' {
        It 'Should call correct API endpoint' {
            Get-TfcAssessmentResultLog -AssessmentResultId 'asmtresult-abc123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/assessment-results/asmtresult-abc123/log-output'
            }
        }
    }
}
