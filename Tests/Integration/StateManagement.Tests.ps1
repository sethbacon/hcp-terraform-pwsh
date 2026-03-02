# Integration Test: State Management Workflow
# Tests state version management, locking, and rollback operations

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

Describe 'State Management Integration Test' -Tag 'Integration', 'State' {
    BeforeAll {
        $testWorkspaceId = 'ws-test123'
    }

    Context 'State Version Lifecycle' {
        It 'Step 1: Get current state version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sv-current-123'
                        type = 'state-versions'
                        attributes = @{
                            serial = 5
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            'hosted-state-download-url' = 'https://example.com/state'
                        }
                    }
                }
            }

            $current = Get-TfcCurrentStateVersion -WorkspaceId $testWorkspaceId

            $current.data.id | Should -Be 'sv-current-123'
            $current.data.attributes.serial | Should -Be 5
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: List state versions' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'sv-5'
                            attributes = @{
                                serial = 5
                                'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            }
                        },
                        @{
                            id = 'sv-4'
                            attributes = @{
                                serial = 4
                                'created-at' = (Get-Date).AddHours(-1).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            }
                        }
                    )
                }
            }

            $versions = Get-TfcStateVersion -WorkspaceId $testWorkspaceId

            $versions.data.Count | Should -Be 2
            $versions.data[0].attributes.serial | Should -Be 5
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Download state file' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sv-current-123'
                        attributes = @{
                            'hosted-state-download-url' = 'https://example.com/state'
                        }
                    }
                }
            }

            Mock Invoke-RestMethod -ModuleName TerraformCloud {
                return @{
                    version = 4
                    terraform_version = '1.5.0'
                    serial = 5
                    lineage = 'test-lineage-123'
                    outputs = @{}
                    resources = @()
                }
            }

            $state = Get-TfcStateFile -StateVersionId 'sv-current-123'

            $state.version | Should -Be 4
            $state.serial | Should -Be 5
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Get state version outputs' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'wsout-123'
                            type = 'state-version-outputs'
                            attributes = @{
                                name = 'instance_ip'
                                value = '192.168.1.100'
                                sensitive = $false
                            }
                        }
                    )
                }
            }

            $outputs = Get-TfcStateVersionOutput -StateVersionId 'sv-current-123'

            $outputs.data.Count | Should -BeGreaterThan 0
            $outputs.data[0].attributes.name | Should -Be 'instance_ip'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Create new state version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sv-new-456'
                        type = 'state-versions'
                        attributes = @{
                            serial = 6
                            'upload-url' = 'https://example.com/upload'
                        }
                    }
                }
            }

            $testStateData = '{"version": 4, "terraform_version": "1.5.0", "serial": 6}'
            $testMD5 = 'abc123def456'
            $newState = New-TfcStateVersion -WorkspaceId $testWorkspaceId -StateData $testStateData -MD5 $testMD5

            $newState.data.id | Should -Be 'sv-new-456'
            $newState.data.attributes.serial | Should -Be 6
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'State Locking' {
        It 'Step 1: Lock state version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sv-current-123'
                        attributes = @{
                            locked = $true
                        }
                    }
                }
            }

            $locked = Lock-TfcStateVersion -StateVersionId 'sv-current-123' -Confirm:$false

            $locked.data.attributes.locked | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Attempt operations while locked' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                throw [System.Net.WebException]::new("State is locked")
            }

            $testStateData = '{"version": 4}'
            $testMD5 = 'abc123'
            { New-TfcStateVersion -WorkspaceId $testWorkspaceId -StateData $testStateData -MD5 $testMD5 -ErrorAction Stop } |
                Should -Throw "*locked*"
        }

        It 'Step 3: Unlock state version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sv-current-123'
                        attributes = @{
                            locked = $false
                        }
                    }
                }
            }

            $unlocked = Unlock-TfcStateVersion -StateVersionId 'sv-current-123' -Confirm:$false

            $unlocked.data.attributes.locked | Should -BeFalse
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'State Rollback' {
        It 'Should rollback to previous state version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sv-rollback-789'
                        type = 'state-versions'
                        attributes = @{
                            serial = 4
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        }
                    }
                }
            }

            $rollback = Invoke-TfcStateRollback -WorkspaceId $testWorkspaceId -StateVersionId 'sv-4' -Confirm:$false

            $rollback.data.attributes.serial | Should -Be 4
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should verify rollback created new state version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sv-rollback-789'
                        attributes = @{
                            serial = 6
                            'rollback-state-version-id' = 'sv-4'
                        }
                    }
                }
            }

            $current = Get-TfcCurrentStateVersion -WorkspaceId $testWorkspaceId

            $current.data.attributes.'rollback-state-version-id' | Should -Be 'sv-4'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'State JSON Operations' {
        It 'Should create state version from JSON' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sv-json-123'
                        type = 'state-versions'
                        attributes = @{
                            serial = 7
                        }
                    }
                }
            }

            $stateJson = @{
                version = 4
                terraform_version = '1.5.0'
                serial = 7
                lineage = 'test-lineage'
                outputs = @{}
                resources = @()
            } | ConvertTo-Json -Depth 10

            $newState = New-TfcStateVersionJson -WorkspaceId $testWorkspaceId -StateJson $stateJson -Confirm:$false

            $newState.data.id | Should -Be 'sv-json-123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Workspace Resources' {
        It 'Should list workspace resources from current state' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'wsres-123'
                            type = 'workspace-resources'
                            attributes = @{
                                name = 'aws_instance.web'
                                'resource-type' = 'aws_instance'
                                provider = 'aws'
                            }
                        }
                    )
                }
            }

            $resources = Get-TfcWorkspaceResource -WorkspaceId $testWorkspaceId

            $resources.data.Count | Should -BeGreaterThan 0
            $resources.data[0].attributes.name | Should -Be 'aws_instance.web'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should get specific resource details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'wsres-123'
                        attributes = @{
                            name = 'aws_instance.web'
                            'resource-type' = 'aws_instance'
                            module = 'root'
                        }
                    }
                }
            }

            $resource = Get-TfcWorkspaceResourceDetails -ResourceId 'wsres-123'

            $resource.data.attributes.name | Should -Be 'aws_instance.web'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


