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

Describe 'Invoke-TfcRegistryModuleTestConfigUpload' {
    BeforeEach {
        Mock Invoke-RestMethod -ModuleName TerraformCloud
        Mock Test-Path -ModuleName TerraformCloud -MockWith { return $true }
    }

    Context 'Parameter Validation' {
        It 'Should have UploadUrl parameter as mandatory' {
            $command = Get-Command Invoke-TfcRegistryModuleTestConfigUpload
            $command.Parameters['UploadUrl'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have TarballPath parameter as mandatory' {
            $command = Get-Command Invoke-TfcRegistryModuleTestConfigUpload
            $command.Parameters['TarballPath'].Attributes.Mandatory | Should -Be $true
        }
    }

}
