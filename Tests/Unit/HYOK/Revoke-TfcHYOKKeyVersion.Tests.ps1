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

Describe 'Revoke-TfcHYOKKeyVersion' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have KeyVersionId parameter as mandatory' {
            $command = Get-Command Revoke-TfcHYOKKeyVersion
            $command.Parameters['KeyVersionId'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with POST' {
            Revoke-TfcHYOKKeyVersion -KeyVersionId 'hkv-abc123' -Confirm:$false
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/hyok-customer-key-versions/hkv-abc123/actions/revoke' -and $Method -eq 'POST'
            }
        }
    }

    Context 'ShouldProcess' {
        It 'Should not call API when WhatIf is specified' {
            Revoke-TfcHYOKKeyVersion -KeyVersionId 'hkv-abc123' -WhatIf
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = Revoke-TfcHYOKKeyVersion -KeyVersionId 'hkv-abc123' -Confirm:$false -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
