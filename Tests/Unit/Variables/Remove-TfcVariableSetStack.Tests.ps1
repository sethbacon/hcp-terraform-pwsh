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

Describe 'Remove-TfcVariableSetStack' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }

    Context 'Parameter Validation' {
        It 'Should have VariableSetId parameter as mandatory' {
            $command = Get-Command Remove-TfcVariableSetStack
            $command.Parameters['VariableSetId'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with DELETE' {
            Remove-TfcVariableSetStack -VariableSetId 'varset-abc123' -StackIds @('stack-123') -Confirm:$false
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/varsets/varset-abc123/relationships/stacks' -and $Method -eq 'DELETE'
            }
        }
    }

    Context 'ShouldProcess' {
        It 'Should not call API when WhatIf is specified' {
            Remove-TfcVariableSetStack -VariableSetId 'varset-abc123' -StackIds @('stack-123') -WhatIf
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
}
