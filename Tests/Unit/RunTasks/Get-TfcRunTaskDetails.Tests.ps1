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
Describe 'Get-TfcRunTaskDetails' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }
    Context 'Parameter Validation' {
        It 'Should have TaskId parameter as mandatory' {
            (Get-Command Get-TfcRunTaskDetails).Parameters['TaskId'].Attributes.Mandatory | Should -Be $true
        }
    }
    Context 'API Interaction' {
        It 'Should call correct API endpoint' {
            Get-TfcRunTaskDetails -TaskId 'task-abc123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/tasks/task-abc123'
            }
        }
    }
}
