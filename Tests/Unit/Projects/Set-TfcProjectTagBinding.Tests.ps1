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

Describe 'Set-TfcProjectTagBinding' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }

    Context 'Parameter Validation' {
        It 'Should have ProjectId parameter as mandatory' {
            $command = Get-Command Set-TfcProjectTagBinding
            $command.Parameters['ProjectId'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with PATCH' {
            Set-TfcProjectTagBinding -ProjectId 'prj-abc123' -TagBindings @(@{key='env'; value='prod'}) -Confirm:$false
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/projects/prj-abc123/tag-bindings' -and $Method -eq 'PATCH'
            }
        }
    }

    Context 'ShouldProcess' {
        It 'Should not call API when WhatIf is specified' {
            Set-TfcProjectTagBinding -ProjectId 'prj-abc123' -TagBindings @(@{key='env'; value='prod'}) -WhatIf
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
}
