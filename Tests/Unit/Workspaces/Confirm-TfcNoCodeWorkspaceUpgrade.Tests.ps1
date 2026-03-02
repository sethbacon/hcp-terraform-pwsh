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

Describe 'Confirm-TfcNoCodeWorkspaceUpgrade' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with POST' {
            Confirm-TfcNoCodeWorkspaceUpgrade -NoCodeModuleId 'nocode-abc123' -WorkspaceId 'ws-abc123' -UpgradeId 'upgrade-abc123' -Confirm:$false
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/no-code-modules/nocode-abc123/workspaces/ws-abc123/upgrade/upgrade-abc123/confirm' -and $Method -eq 'POST'
            }
        }
    }

    Context 'ShouldProcess' {
        It 'Should not call API when WhatIf is specified' {
            Confirm-TfcNoCodeWorkspaceUpgrade -NoCodeModuleId 'nocode-abc123' -WorkspaceId 'ws-abc123' -UpgradeId 'upgrade-abc123' -WhatIf
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
}
