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
Describe 'Get-TfcGroupMemberRoleDetails' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }
    Context 'Parameter Validation' {
        It 'Should have ResourceType parameter as mandatory' {
            (Get-Command Get-TfcGroupMemberRoleDetails).Parameters['ResourceType'].Attributes.Mandatory | Should -Be $true
        }
        It 'Should have ResourceId parameter as mandatory' {
            (Get-Command Get-TfcGroupMemberRoleDetails).Parameters['ResourceId'].Attributes.Mandatory | Should -Be $true
        }
        It 'Should have GroupId parameter as mandatory' {
            (Get-Command Get-TfcGroupMemberRoleDetails).Parameters['GroupId'].Attributes.Mandatory | Should -Be $true
        }
    }
    Context 'API Interaction' {
        It 'Should call correct API endpoint' {
            Get-TfcGroupMemberRoleDetails -ResourceType 'organizations' -ResourceId 'org-abc123' -GroupId 'grp-abc123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}
