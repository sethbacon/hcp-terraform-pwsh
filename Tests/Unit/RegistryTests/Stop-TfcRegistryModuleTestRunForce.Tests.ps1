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

Describe 'Stop-TfcRegistryModuleTestRunForce' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have TestRunId parameter as mandatory' {
            $command = Get-Command Stop-TfcRegistryModuleTestRunForce
            $command.Parameters['TestRunId'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with POST' {
            Stop-TfcRegistryModuleTestRunForce -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws' -TestRunId 'trun-abc123' -Confirm:$false
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -like '*/test-runs/trun-abc123/force-cancel' -and $Method -eq 'POST'
            }
        }
    }

    Context 'ShouldProcess' {
        It 'Should not call API when WhatIf is specified' {
            Stop-TfcRegistryModuleTestRunForce -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws' -TestRunId 'trun-abc123' -WhatIf
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose message' {
            $verboseOutput = Stop-TfcRegistryModuleTestRunForce -Organization 'test-org' -ModuleName 'test-module' -ProviderName 'aws' -TestRunId 'trun-abc123' -Confirm:$false -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
