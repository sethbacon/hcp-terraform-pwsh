# Integration Test: Run Trigger Workflow
# Tests cascading run triggers between source and target workspaces

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

Describe 'Run Trigger Workflow Integration Test' -Tag 'Integration', 'RunTriggers' {
    BeforeAll {
        $sourceWorkspaceId = 'ws-source-123'
        $targetWorkspaceId = 'ws-target-456'
    }

    Context 'Run Trigger Lifecycle' {
        It 'Step 1: Create run trigger' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'rt-integration-123'
                        type = 'run-triggers'
                        attributes = @{
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        }
                        relationships = @{
                            sourceable = @{
                                data = @{
                                    id = $sourceWorkspaceId
                                    type = 'workspaces'
                                }
                            }
                            workspace = @{
                                data = @{
                                    id = $targetWorkspaceId
                                    type = 'workspaces'
                                }
                            }
                        }
                    }
                }
            }

            $trigger = New-TfcRunTrigger -TargetWorkspaceId $targetWorkspaceId `
                -SourceWorkspaceId $sourceWorkspaceId

            $trigger.data.id | Should -Be 'rt-integration-123'
            $trigger.data.relationships.sourceable.data.id | Should -Be $sourceWorkspaceId
            $trigger.data.relationships.workspace.data.id | Should -Be $targetWorkspaceId
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Get run trigger details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'rt-integration-123'
                        type = 'run-triggers'
                        attributes = @{
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        }
                        relationships = @{
                            sourceable = @{
                                data = @{
                                    id = $sourceWorkspaceId
                                }
                            }
                        }
                    }
                }
            }

            $details = Show-TfcRunTrigger -RunTriggerId 'rt-integration-123'

            $details.data.id | Should -Be 'rt-integration-123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: List run triggers for workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'rt-integration-123'
                            type = 'run-triggers'
                            attributes = @{
                                'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            }
                        }
                    )
                }
            }

            $triggers = Get-TfcRunTrigger -WorkspaceId $targetWorkspaceId

            $triggers.data.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Delete run trigger' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcRunTrigger -RunTriggerId 'rt-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Cascading Run Behavior' {
        It 'Should trigger run in target workspace when source completes' {
            # Mock creating a run in source workspace
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)

                if ($Uri -eq '/runs' -and $Method -eq 'POST') {
                    return @{
                        data = @{
                            id = 'run-source-123'
                            attributes = @{
                                status = 'applied'
                                message = 'Source workspace run'
                            }
                        }
                    }
                }

                # Mock the triggered run in target workspace
                if ($Uri -like '*/workspaces/*/runs*' -and $Method -ne 'POST') {
                    return @{
                        data = @(
                            @{
                                id = 'run-target-456'
                                attributes = @{
                                    status = 'planning'
                                    message = 'Triggered by run-source-123'
                                    'trigger-reason' = 'run-trigger'
                                }
                            }
                        )
                    }
                }
            }

            # Create run in source workspace
            $sourceRun = New-TfcRun -WorkspaceId $sourceWorkspaceId -Message "Test run"
            $sourceRun.data.id | Should -Be 'run-source-123'

            # Verify triggered run in target workspace
            $targetRuns = Get-TfcRun -WorkspaceId $targetWorkspaceId
            $targetRuns.data[0].attributes.'trigger-reason' | Should -Be 'run-trigger'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2
        }
    }

    Context 'Multiple Run Triggers' {
        It 'Should support multiple source workspaces triggering one target' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)

                return @{
                    data = @{
                        id = "rt-multi-$(Get-Random)"
                        type = 'run-triggers'
                        relationships = @{
                            sourceable = @{
                                data = @{
                                    id = $Body.data.relationships.sourceable.data.id
                                }
                            }
                            workspace = @{
                                data = @{
                                    id = $targetWorkspaceId
                                }
                            }
                        }
                    }
                }
            }

            # Create first trigger
            $trigger1 = New-TfcRunTrigger -TargetWorkspaceId $targetWorkspaceId `
                -SourceWorkspaceId 'ws-source-1'

            # Create second trigger
            $trigger2 = New-TfcRunTrigger -TargetWorkspaceId $targetWorkspaceId `
                -SourceWorkspaceId 'ws-source-2'

            $trigger1.data.relationships.workspace.data.id | Should -Be $targetWorkspaceId
            $trigger2.data.relationships.workspace.data.id | Should -Be $targetWorkspaceId
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2
        }

        It 'Should support one source workspace triggering multiple targets' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)

                return @{
                    data = @{
                        id = "rt-fan-$(Get-Random)"
                        type = 'run-triggers'
                        relationships = @{
                            sourceable = @{
                                data = @{
                                    id = $sourceWorkspaceId
                                }
                            }
                            workspace = @{
                                data = @{
                                    id = $Body.data.relationships.workspace.data.id
                                }
                            }
                        }
                    }
                }
            }

            # Create trigger to first target
            $trigger1 = New-TfcRunTrigger -TargetWorkspaceId 'ws-target-1' `
                -SourceWorkspaceId $sourceWorkspaceId

            # Create trigger to second target
            $trigger2 = New-TfcRunTrigger -TargetWorkspaceId 'ws-target-2' `
                -SourceWorkspaceId $sourceWorkspaceId

            $trigger1.data.relationships.sourceable.data.id | Should -Be $sourceWorkspaceId
            $trigger2.data.relationships.sourceable.data.id | Should -Be $sourceWorkspaceId
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2
        }
    }

    Context 'Run Trigger Validation' {
        It 'Should prevent circular dependencies' {
            # In real implementation, this would be validated by the API
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                throw [System.Net.WebException]::new("Circular dependency detected")
            }

            # Try to create trigger that would create a loop
            { New-TfcRunTrigger -TargetWorkspaceId $sourceWorkspaceId `
                -SourceWorkspaceId $targetWorkspaceId -ErrorAction Stop } |
                Should -Throw "*Circular dependency*"
        }

        It 'Should handle duplicate trigger creation' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                throw [System.Net.WebException]::new("Run trigger already exists")
            }

            # Try to create duplicate trigger
            { New-TfcRunTrigger -TargetWorkspaceId $targetWorkspaceId `
                -SourceWorkspaceId $sourceWorkspaceId -ErrorAction Stop } |
                Should -Throw "*already exists*"
        }
    }
}


