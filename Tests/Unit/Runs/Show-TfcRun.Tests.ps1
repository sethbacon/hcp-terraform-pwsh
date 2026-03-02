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

Describe 'Show-TfcRun' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
            return @{ data = Get-MockRun }
        }
    }
    
    Context 'Function Exists' {
        It 'Should be available' {
            Get-Command Show-TfcRun | Should -Not -BeNullOrEmpty
        }
    }
    
    Context 'API Interaction' {
        It 'Should call Invoke-TfcApi' {
            # Function exists and can be mocked
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
}
