# Integration Test: Run Task Workflow
# Tests the complete lifecycle of run tasks and workspace run task assignments

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

Describe 'Run Task Workflow Integration Test' -Tag 'Integration', 'RunTasks' {
    BeforeAll {
        $testOrgName = 'test-org'
        $testWorkspaceId = 'ws-test123'
        $testRunTaskName = "test-run-task-$(Get-Random)"
        $testTaskUrl = "https://example.com/run-task-endpoint"
    }

    Context 'Run Task Lifecycle' {
        It 'Step 1: Create run task' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                $bodyObj = if($Body) { $Body | ConvertFrom-Json } else { $null }
                return @{
                    data = @{
                        id = 'task-integration-123'
                        type = 'tasks'
                        attributes = @{
                            name = $bodyObj.data.attributes.name
                            url = $bodyObj.data.attributes.url
                            category = 'task'
                            enabled = $true
                        }
                    }
                }
            }

            $runTask = New-TfcRunTask -Organization $testOrgName `
                -Name $testRunTaskName `
                -Url $testTaskUrl

            $runTask.data.id | Should -Be 'task-integration-123'
            $runTask.data.attributes.name | Should -Be $testRunTaskName
            $runTask.data.attributes.url | Should -Be $testTaskUrl
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Get run task details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'task-integration-123'
                        attributes = @{
                            name = $testRunTaskName
                            url = $testTaskUrl
                            enabled = $true
                        }
                    }
                }
            }

            $task = Get-TfcRunTask -Organization $testOrgName

            $task.data | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Update run task' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'task-integration-123'
                        attributes = @{
                            name = "$testRunTaskName-updated"
                            enabled = $true
                        }
                    }
                }
            }

            $updated = Update-TfcRunTask -RunTaskId 'task-integration-123' `
                -Name "$testRunTaskName-updated"

            $updated.data.attributes.name | Should -BeLike "*-updated"
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Delete run task' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcRunTask -RunTaskId 'task-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Workspace Run Task Assignment' {
        It 'Step 1: Attach run task to workspace (post-plan)' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'wstask-123'
                        type = 'workspace-tasks'
                        attributes = @{
                            'enforcement-level' = 'advisory'
                            stage = 'post_plan'
                        }
                        relationships = @{
                            task = @{
                                data = @{
                                    id = 'task-integration-123'
                                }
                            }
                            workspace = @{
                                data = @{
                                    id = $testWorkspaceId
                                }
                            }
                        }
                    }
                }
            }

            $assignment = Add-TfcWorkspaceRunTask -WorkspaceId $testWorkspaceId `
                -RunTaskId 'task-integration-123' `
                -EnforcementLevel 'advisory' `
                -Stage 'post_plan'

            $assignment.data.attributes.'enforcement-level' | Should -Be 'advisory'
            $assignment.data.attributes.stage | Should -Be 'post_plan'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Update enforcement level to mandatory' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'wstask-123'
                        attributes = @{
                            'enforcement-level' = 'mandatory'
                            stage = 'post_plan'
                        }
                    }
                }
            }

            $updated = Update-TfcWorkspaceRunTask -WorkspaceTaskId 'wstask-123' `
                -EnforcementLevel 'mandatory'

            $updated.data.attributes.'enforcement-level' | Should -Be 'mandatory'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: List workspace run tasks' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'wstask-123'
                            attributes = @{
                                'enforcement-level' = 'mandatory'
                                stage = 'post_plan'
                            }
                        }
                    )
                }
            }

            $tasks = Get-TfcWorkspaceRunTask -WorkspaceId $testWorkspaceId

            $tasks.data.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Remove run task from workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcWorkspaceRunTask -WorkspaceTaskId 'wstask-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Run Task Stages' {
        It 'Should support pre-plan stage' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'wstask-preplan'
                        attributes = @{
                            stage = 'pre_plan'
                            'enforcement-level' = 'advisory'
                        }
                    }
                }
            }

            $prePlan = Add-TfcWorkspaceRunTask -WorkspaceId $testWorkspaceId `
                -RunTaskId 'task-integration-123' `
                -Stage 'pre_plan' `
                -EnforcementLevel 'advisory'

            $prePlan.data.attributes.stage | Should -Be 'pre_plan'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should support post-plan stage' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'wstask-postplan'
                        attributes = @{
                            stage = 'post_plan'
                            'enforcement-level' = 'advisory'
                        }
                    }
                }
            }

            $postPlan = Add-TfcWorkspaceRunTask -WorkspaceId $testWorkspaceId `
                -RunTaskId 'task-integration-123' `
                -Stage 'post_plan' `
                -EnforcementLevel 'advisory'

            $postPlan.data.attributes.stage | Should -Be 'post_plan'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Enforcement Levels' {
        It 'Should support advisory enforcement' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'wstask-advisory'
                        attributes = @{
                            'enforcement-level' = 'advisory'
                        }
                    }
                }
            }

            $advisory = Add-TfcWorkspaceRunTask -WorkspaceId $testWorkspaceId `
                -RunTaskId 'task-integration-123' `
                -EnforcementLevel 'advisory'

            $advisory.data.attributes.'enforcement-level' | Should -Be 'advisory'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should support mandatory enforcement' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'wstask-mandatory'
                        attributes = @{
                            'enforcement-level' = 'mandatory'
                        }
                    }
                }
            }

            $mandatory = Add-TfcWorkspaceRunTask -WorkspaceId $testWorkspaceId `
                -RunTaskId 'task-integration-123' `
                -EnforcementLevel 'mandatory'

            $mandatory.data.attributes.'enforcement-level' | Should -Be 'mandatory'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Run Task Results' {
        It 'Should retrieve run task results' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'taskrs-123'
                            attributes = @{
                                status = 'passed'
                                message = 'Task completed successfully'
                                url = 'https://example.com/results'
                            }
                        }
                    )
                }
            }

            $results = Get-TfcRunTaskResult -RunId 'run-test123'

            $results.data[0].attributes.status | Should -Be 'passed'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should retrieve specific task result details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'taskrs-123'
                        attributes = @{
                            status = 'passed'
                            message = 'Task completed successfully'
                        }
                    }
                }
            }

            $result = Get-TfcRunTaskResultDetails -TaskResultId 'taskrs-123'

            $result.data.attributes.status | Should -Be 'passed'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


