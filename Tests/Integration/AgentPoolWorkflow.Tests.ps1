# Integration Test: Agent Pool Workflow
# Tests agent pool creation, agent tokens, and workspace agent execution

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

Describe 'Agent Pool Workflow Integration Test' -Tag 'Integration', 'Agents' {
    BeforeAll {
        $testOrgName = 'test-org'
        $testAgentPoolName = "test-agent-pool-$(Get-Random)"
        $testWorkspaceId = 'ws-test123'
    }

    Context 'Agent Pool Lifecycle' {
        It 'Step 1: Create agent pool' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                return @{
                    data = @{
                        id = 'apool-integration-123'
                        type = 'agent-pools'
                        attributes = @{
                            name = $bodyObj.data.attributes.name
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        }
                    }
                }
            }

            $pool = New-TfcAgentPool -Organization $testOrgName -Name $testAgentPoolName

            $pool.data.id | Should -Be 'apool-integration-123'
            $pool.data.attributes.name | Should -Be $testAgentPoolName
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Generate agent token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'at-integration-123'
                        type = 'authentication-tokens'
                        attributes = @{
                            description = $Body.data.attributes.description
                            token = 'mock-agent-token-value-abc123'
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        }
                    }
                }
            }

            $token = New-TfcAgentToken -AgentPoolId 'apool-integration-123' `
                -Description "Integration test agent token"

            $token.data.attributes.token | Should -Match 'mock-agent-token'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: List agent tokens' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'at-integration-123'
                            attributes = @{
                                description = "Integration test agent token"
                            }
                        }
                    )
                }
            }

            $tokens = Get-TfcAgentToken -AgentPoolId 'apool-integration-123'

            $tokens.data.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: List agents in pool' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'agent-123'
                            attributes = @{
                                name = 'test-agent-1'
                                status = 'idle'
                                'ip-address' = '10.0.1.100'
                            }
                        }
                    )
                }
            }

            $agents = Get-TfcAgent -AgentPoolId 'apool-integration-123'

            $agents.data.Count | Should -BeGreaterThan 0
            $agents.data[0].attributes.status | Should -Be 'idle'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Configure workspace for agent execution' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-test123'
                        attributes = @{
                            'execution-mode' = 'agent'
                        }
                        relationships = @{
                            'agent-pool' = @{
                                data = @{
                                    id = 'apool-integration-123'
                                }
                            }
                        }
                    }
                }
            }

            $workspace = Update-TfcWorkspace -Organization $testOrgName `
                -Name 'test-workspace'

            $workspace.data.attributes.'execution-mode' | Should -Be 'agent'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 6: Update agent pool' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'apool-integration-123'
                        attributes = @{
                            name = "$testAgentPoolName-updated"
                        }
                    }
                }
            }

            $updated = Update-TfcAgentPool -AgentPoolId 'apool-integration-123' `
                -Name "$testAgentPoolName-updated"

            $updated.data.attributes.name | Should -BeLike "*-updated"
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 7: Delete agent token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $true
            }

            $result = Remove-TfcAgentToken -AgentTokenId 'at-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 8: Delete agent pool' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $true
            }

            $result = Remove-TfcAgentPool -AgentPoolId 'apool-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Agent Status Monitoring' {
        It 'Should show agent status correctly' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'agent-idle'
                            attributes = @{
                                name = 'agent-1'
                                status = 'idle'
                            }
                        },
                        @{
                            id = 'agent-busy'
                            attributes = @{
                                name = 'agent-2'
                                status = 'busy'
                            }
                        }
                    )
                }
            }

            $agents = Get-TfcAgent -AgentPoolId 'apool-integration-123'

            $idleAgents = @($agents.data | Where-Object { $_.attributes.status -eq 'idle' })
            $busyAgents = @($agents.data | Where-Object { $_.attributes.status -eq 'busy' })

            $idleAgents.Count | Should -Be 1
            $busyAgents.Count | Should -Be 1
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


