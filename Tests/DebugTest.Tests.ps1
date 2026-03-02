Import-Module "./Output/TerraformCloud/TerraformCloud.psd1" -Force
Describe "Debug Test" {
    It "Should test Remove-TfcWorkspaceSafely" {
        Mock Invoke-TfcApi -ModuleName TerraformCloud {
            return @{
                data = @{
                    id = 'ws-abc123xyz'
                    attributes = @{ 'resource-count' = 0 }
                }
            }
        } -ParameterFilter { $Method -ne 'DELETE' }

        Mock Invoke-TfcApi -ModuleName TerraformCloud {
            return $null
        } -ParameterFilter { $Method -eq 'DELETE' }

        $result = Remove-TfcWorkspaceSafely -Organization "test-org" -WorkspaceName "test-ws" -Force -Confirm:$false -Verbose
        Write-Host "Result: $result"
        Write-Host "Result Type: $($result.GetType().Name)"
        $result | Should -BeTrue
    }
}
