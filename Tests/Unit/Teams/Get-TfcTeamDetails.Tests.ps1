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
Describe 'Get-TfcTeamDetails' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }
    Context 'Parameter Validation' {
        It 'Should have TeamId parameter as mandatory' {
            (Get-Command Get-TfcTeamDetails).Parameters['TeamId'].Attributes.Mandatory | Should -Be $true
        }
    }
    Context 'API Interaction' {
        It 'Should call correct API endpoint' {
            Get-TfcTeamDetails -TeamId 'team-abc123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/teams/team-abc123'
            }
        }
    }
}
