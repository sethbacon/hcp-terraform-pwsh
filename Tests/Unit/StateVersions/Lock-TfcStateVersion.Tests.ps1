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

Describe 'Lock-TfcStateVersion' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have StateVersionId parameter as mandatory' {
            $command = Get-Command Lock-TfcStateVersion
            $command.Parameters['StateVersionId'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Reason parameter as optional' {
            $command = Get-Command Lock-TfcStateVersion
            $command.Parameters['Reason'].Attributes.Mandatory | Should -Be $false
        }

        It 'Should support ShouldProcess' {
            $command = Get-Command Lock-TfcStateVersion
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }
    }

    Context 'Locking state version' {
        It 'Should call correct API endpoint with PATCH method' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockStateVersion }
            }

            Lock-TfcStateVersion -StateVersionId 'sv-123' -Confirm:$false

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/state-versions/sv-123' -and
                $Method -eq 'Patch'
            }
        }

        It 'Should set locked attribute to true in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.locked | Should -Be $true
                return @{ data = Get-MockStateVersion }
            }

            Lock-TfcStateVersion -StateVersionId 'sv-123' -Confirm:$false
        }

        It 'Should include state version type in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.type | Should -Be 'state-versions'
                return @{ data = Get-MockStateVersion }
            }

            Lock-TfcStateVersion -StateVersionId 'sv-123' -Confirm:$false
        }

        It 'Should include state version ID in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.id | Should -Be 'sv-456'
                return @{ data = Get-MockStateVersion }
            }

            Lock-TfcStateVersion -StateVersionId 'sv-456' -Confirm:$false
        }
    }

    Context 'ShouldProcess support' {
        It 'Should not lock state when WhatIf is specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud

            Lock-TfcStateVersion -StateVersionId 'sv-123' -WhatIf

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
}
