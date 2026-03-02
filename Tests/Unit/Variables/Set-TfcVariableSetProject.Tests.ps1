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

Describe 'Set-TfcVariableSetProject' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }

    Context 'Parameter Validation' {
        It 'Should have VariableSetId parameter as mandatory' {
            $command = Get-Command Set-TfcVariableSetProject
            $command.Parameters['VariableSetId'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'API Interaction' {
        It 'Should call correct API endpoint with POST' {
            Set-TfcVariableSetProject -VariableSetId 'varset-abc123' -ProjectIds @('prj-123') -Confirm:$false
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/varsets/varset-abc123/relationships/projects' -and $Method -eq 'POST'
            }
        }
    }

}
