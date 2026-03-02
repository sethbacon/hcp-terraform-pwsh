Import-Module "./Output/TerraformCloud/TerraformCloud.psd1" -Force
Describe "Debug Test 2" {
    It "Should test Remove-TfcWorkspaceSafely without verbose" {
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

        $result = Remove-TfcWorkspaceSafely -Organization "test-org" -WorkspaceName "test-ws" -Force -Confirm:$false
        Write-Host "Result: [$result]"
        Write-Host "Result is null: $($null -eq $result)"
        Write-Host "Result count: $($result.Count)"
        if ($result -is [array]) {
            Write-Host "Result[0]: [$($result[0])]"
            Write-Host "Result[-1]: [$($result[-1])]"
        }
        $result | Should -BeTrue
    }
}
