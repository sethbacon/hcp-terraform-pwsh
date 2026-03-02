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
Describe 'Update-TfcAccountPassword' {
    BeforeEach { Mock Invoke-TfcApi -ModuleName TerraformCloud }
    Context 'Parameter Validation' {
        It 'Should have CurrentPassword parameter as mandatory' {
            (Get-Command Update-TfcAccountPassword).Parameters['CurrentPassword'].Attributes.Mandatory | Should -Be $true
        }
        It 'Should have NewPassword parameter as mandatory' {
            (Get-Command Update-TfcAccountPassword).Parameters['NewPassword'].Attributes.Mandatory | Should -Be $true
        }
        It 'Should have NewPasswordConfirmation parameter as mandatory' {
            (Get-Command Update-TfcAccountPassword).Parameters['NewPasswordConfirmation'].Attributes.Mandatory | Should -Be $true
        }
    }
    Context 'API Interaction' {
        It 'Should call correct API endpoint with PATCH' {
            $securePass = ConvertTo-SecureString 'testpass' -AsPlainText -Force
            Update-TfcAccountPassword -CurrentPassword $securePass -NewPassword $securePass -NewPasswordConfirmation $securePass
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/account/password' -and $Method -eq 'PATCH'
            }
        }
    }
}
