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

Describe 'Update-TfcPolicySetParameter' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have ParameterId as mandatory' {
            $command = Get-Command Update-TfcPolicySetParameter
            $command.Parameters['ParameterId'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should support ShouldProcess' {
            $command = Get-Command Update-TfcPolicySetParameter
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
        }
    }

    Context 'Updating parameter' {
        It 'Should call correct API endpoint with PATCH method' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockPolicySetParameter }
            }

            Update-TfcPolicySetParameter -ParameterId 'param-123' -Value 'new-value' -Confirm:$false

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/policy-set-parameters/param-123' -and $Method -eq 'Patch'
            }
        }

        It 'Should include new value in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.value | Should -Be 'updated-value'
                return @{ data = Get-MockPolicySetParameter }
            }

            Update-TfcPolicySetParameter -ParameterId 'param-123' -Value 'updated-value' -Confirm:$false
        }

        It 'Should not call API when WhatIf is used' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud

            Update-TfcPolicySetParameter -ParameterId 'param-123' -Value 'new' -WhatIf

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
}
