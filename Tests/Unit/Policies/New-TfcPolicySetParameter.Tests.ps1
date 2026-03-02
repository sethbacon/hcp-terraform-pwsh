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

Describe 'New-TfcPolicySetParameter' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have PolicySetId parameter as mandatory' {
            $command = Get-Command New-TfcPolicySetParameter
            $command.Parameters['PolicySetId'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Key parameter as mandatory' {
            $command = Get-Command New-TfcPolicySetParameter
            $command.Parameters['Key'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Value parameter as mandatory' {
            $command = Get-Command New-TfcPolicySetParameter
            $command.Parameters['Value'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Sensitive as switch parameter' {
            $command = Get-Command New-TfcPolicySetParameter
            $command.Parameters['Sensitive'].SwitchParameter | Should -Be $true
        }

        It 'Should have Category with ValidateSet' {
            $command = Get-Command New-TfcPolicySetParameter
            $validateSet = $command.Parameters['Category'].Attributes.Where({$_.TypeId.Name -eq 'ValidateSetAttribute'})
            $validateSet.ValidValues | Should -Contain 'policy-set'
        }

        It 'Should support ShouldProcess' {
            $command = Get-Command New-TfcPolicySetParameter
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }
    }

    Context 'Creating policy set parameter' {
        It 'Should call correct API endpoint with POST method' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockPolicySetParameter }
            }

            New-TfcPolicySetParameter -PolicySetId 'polset-123' -Key 'env' -Value 'prod' -Confirm:$false

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/policy-sets/polset-123/parameters' -and
                $Method -eq 'Post'
            }
        }

        It 'Should include parameter key in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.key | Should -Be 'environment'
                return @{ data = Get-MockPolicySetParameter }
            }

            New-TfcPolicySetParameter -PolicySetId 'polset-123' -Key 'environment' -Value 'production' -Confirm:$false
        }

        It 'Should include parameter value in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.value | Should -Be 'production'
                return @{ data = Get-MockPolicySetParameter }
            }

            New-TfcPolicySetParameter -PolicySetId 'polset-123' -Key 'env' -Value 'production' -Confirm:$false
        }

        It 'Should set sensitive to false by default' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.sensitive | Should -Be $false
                return @{ data = Get-MockPolicySetParameter }
            }

            New-TfcPolicySetParameter -PolicySetId 'polset-123' -Key 'env' -Value 'prod' -Confirm:$false
        }

        It 'Should set sensitive to true when Sensitive switch is used' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.sensitive | Should -Be $true
                return @{ data = Get-MockPolicySetParameter -Sensitive $true }
            }

            New-TfcPolicySetParameter -PolicySetId 'polset-123' -Key 'secret' -Value 'value' -Sensitive -Confirm:$false
        }

        It 'Should set default category to policy-set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.category | Should -Be 'policy-set'
                return @{ data = Get-MockPolicySetParameter }
            }

            New-TfcPolicySetParameter -PolicySetId 'polset-123' -Key 'env' -Value 'prod' -Confirm:$false
        }
    }

    Context 'ShouldProcess support' {
        It 'Should not create parameter when WhatIf is specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud

            New-TfcPolicySetParameter -PolicySetId 'polset-123' -Key 'env' -Value 'prod' -WhatIf

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }

        It 'Should return parameter data on successful creation' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockPolicySetParameter }
            }

            $result = New-TfcPolicySetParameter -PolicySetId 'polset-123' -Key 'env' -Value 'prod' -Confirm:$false

            $result.data | Should -Not -BeNullOrEmpty
        }
    }
}
