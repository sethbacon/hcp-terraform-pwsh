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
Describe 'Get-TfcChangeRequestComment' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }
    Context 'Parameter Validation' {
        It 'Should have ChangeRequestId parameter as mandatory' {
            (Get-Command Get-TfcChangeRequestComment).Parameters['ChangeRequestId'].Attributes.Mandatory | Should -Be $true
        }
    }
    Context 'API Interaction' {
        It 'Should call correct API endpoint' {
            Get-TfcChangeRequestComment -ChangeRequestId 'cr-abc123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/change-requests/cr-abc123/comments'
            }
        }
    }
}
