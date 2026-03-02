Import-Module "./Output/TerraformCloud/TerraformCloud.psd1" -Force
Describe "Mock Test" {
    It "Should mock Invoke-TfcApi" {
        Mock Invoke-TfcApi -ModuleName TerraformCloud {
            return @{ data = @{ id = "test-123" } }
        }
        
        $result = New-TfcWorkspace -Organization "test-org" -Name "test-ws"
        $result | Should -Not -BeNull
    }
}
