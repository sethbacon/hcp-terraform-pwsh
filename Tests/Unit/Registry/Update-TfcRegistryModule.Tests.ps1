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
Describe 'Update-TfcRegistryModule' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }
    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            (Get-Command Update-TfcRegistryModule).Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }
        It 'Should have Namespace parameter as mandatory' {
            (Get-Command Update-TfcRegistryModule).Parameters['Namespace'].Attributes.Mandatory | Should -Be $true
        }
        It 'Should have Name parameter as mandatory' {
            (Get-Command Update-TfcRegistryModule).Parameters['Name'].Attributes.Mandatory | Should -Be $true
        }
        It 'Should have Provider parameter as mandatory' {
            (Get-Command Update-TfcRegistryModule).Parameters['Provider'].Attributes.Mandatory | Should -Be $true
        }
    }
    Context 'API Interaction' {
        It 'Should call correct API endpoint with PATCH' {
            Update-TfcRegistryModule -Organization 'test-org' -Namespace 'test-ns' -Name 'test-mod' -Provider 'aws' -Confirm:$false
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/organizations/test-org/registry-modules/private/test-ns/test-mod/aws' -and $Method -eq 'PATCH'
            }
        }
    }
    Context 'ShouldProcess' {
        It 'Should not call API when WhatIf is specified' {
            Update-TfcRegistryModule -Organization 'test-org' -Namespace 'test-ns' -Name 'test-mod' -Provider 'aws' -WhatIf
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
}
