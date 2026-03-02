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

Describe 'New-TfcHYOKConfiguration' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            $command = Get-Command New-TfcHYOKConfiguration
            $command.Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Name parameter as mandatory' {
            $command = Get-Command New-TfcHYOKConfiguration
            $command.Parameters['Name'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with POST' {
            New-TfcHYOKConfiguration -Organization 'test-org' -Name 'test-config' -KeyProviderId 'kp-123' -KeyName 'my-key' -Confirm:$false
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/organizations/test-org/hyok-configurations' -and $Method -eq 'POST'
            }
        }
    }

    Context 'ShouldProcess' {
        It 'Should not call API when WhatIf is specified' {
            New-TfcHYOKConfiguration -Organization 'test-org' -Name 'test-config' -KeyProviderId 'kp-123' -KeyName 'my-key' -WhatIf
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = New-TfcHYOKConfiguration -Organization 'test-org' -Name 'test-config' -KeyProviderId 'kp-123' -KeyName 'my-key' -Confirm:$false -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
