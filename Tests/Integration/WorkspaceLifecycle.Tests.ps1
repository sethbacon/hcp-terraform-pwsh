# Integration Test: Complete Workspace Lifecycle
# Tests the full workflow of creating, configuring, and destroying a workspace

BeforeAll {
    $helpersPath = Join-Path $PSScriptRoot '..' 'Helpers' 'TestHelpers.psm1'
    Import-Module $helpersPath -Force

    $modulePath = Join-Path $PSScriptRoot '..' '..' 'Output' 'TerraformCloud' 'TerraformCloud.psd1'
    Import-Module $modulePath -Force

    $env:TFE_TOKEN = "test-token-12345"
}

AfterAll {
    Remove-Module TerraformCloud -Force -ErrorAction SilentlyContinue
    Remove-Module TestHelpers -Force -ErrorAction SilentlyContinue
}

Describe 'Workspace Lifecycle Integration Test' {
    BeforeAll {
        $testOrgName = 'test-org'
        $testWorkspaceName = 'integration-test-workspace'
    }

    Context 'Complete Workspace Workflow' {
        It 'Step 1: Create workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-abc123xyz'
                        type = 'workspaces'
                        attributes = @{
                            name = $testWorkspaceName
                            'auto-apply' = $false
                            locked = $false
                            'resource-count' = 0
                        }
                    }
                }
            }

            $workspace = New-TfcWorkspace -Organization $testOrgName -Name $testWorkspaceName

            $workspace.data.attributes.name | Should -Be $testWorkspaceName
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Add workspace variables' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'var-123'
                        type = 'vars'
                        attributes = @{
                            key = 'environment'
                            value = 'test'
                        }
                    }
                }
            }

            $variable = Set-TfcWorkspaceVariable -WorkspaceId 'ws-abc123xyz' -Key 'environment' -Value 'test' -Category 'env'

            $variable.data.attributes.key | Should -Be 'environment'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Lock workspace for maintenance' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-abc123xyz'
                        attributes = @{
                            locked = $true
                        }
                    }
                }
            }

            $result = Lock-TfcWorkspace -Organization $testOrgName -Name $testWorkspaceName

            $result.data.attributes.locked | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Unlock workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-abc123xyz'
                        attributes = @{
                            locked = $false
                        }
                    }
                }
            }

            $result = Unlock-TfcWorkspace -Organization $testOrgName -Name $testWorkspaceName

            $result.data.attributes.locked | Should -BeFalse
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Delete workspace safely (no resources)' {
            # Mock workspace details call (GET)
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-abc123xyz'
                        attributes = @{
                            'resource-count' = 0
                        }
                    }
                }
            } -ParameterFilter { $Method -ne 'DELETE' }

            # Mock delete call (DELETE)
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            } -ParameterFilter { $Method -eq 'DELETE' }

            $result = Remove-TfcWorkspaceSafely -Organization $testOrgName -WorkspaceName $testWorkspaceName -Force -Confirm:$false

            # Function returns array due to PowerShell output stream capturing - get last element
            if ($result -is [array]) {
                $result = $result[-1]
            }
            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter { $Method -eq 'DELETE' }
        }
    }
}
