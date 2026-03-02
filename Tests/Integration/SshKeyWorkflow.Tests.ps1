# Integration Test: SSH Key Workflow
# Tests SSH key management for VCS integration

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

Describe 'SSH Key Workflow Integration Test' -Tag 'Integration', 'SSHKeys' {
    BeforeAll {
        $testOrgName = 'test-org'
        $testWorkspaceId = 'ws-test123'
        $testSshKeyName = "test-ssh-key-$(Get-Random)"
    }

    Context 'SSH Key Lifecycle' {
        It 'Step 1: Create SSH key' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                $bodyObj = if($Body) { $Body | ConvertFrom-Json } else { $null }
                return @{
                    data = @{
                        id = 'sshkey-integration-123'
                        type = 'ssh-keys'
                        attributes = @{
                            name = $bodyObj.data.attributes.name
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        }
                    }
                }
            }

            $sshKey = New-TfcSshKey -Organization $testOrgName `
                -Name $testSshKeyName `
                -Value "ssh-rsa AAAAB3NzaC1yc2EAAA... test@example.com"

            $sshKey.data.id | Should -Be 'sshkey-integration-123'
            $sshKey.data.attributes.name | Should -Be $testSshKeyName
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: List SSH keys' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'sshkey-integration-123'
                            attributes = @{
                                name = $testSshKeyName
                            }
                        }
                    )
                }
            }

            $keys = Get-TfcSshKey -Organization $testOrgName

            $keys.data.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Get SSH key details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'sshkey-integration-123'
                            attributes = @{
                                name = $testSshKeyName
                                'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            }
                        }
                    )
                }
            }

            $keys = Get-TfcSSHKey -Organization $testOrgName
            $key = $keys.data | Where-Object { $_.id -eq 'sshkey-integration-123' }

            $key.id | Should -Be 'sshkey-integration-123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Update SSH key name' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'sshkey-integration-123'
                        attributes = @{
                            name = "$testSshKeyName-updated"
                        }
                    }
                }
            }

            $updated = Update-TfcSshKey -SshKeyId 'sshkey-integration-123' `
                -Name "$testSshKeyName-updated"

            $updated.data.attributes.name | Should -BeLike "*-updated"
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Delete SSH key' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcSshKey -SshKeyId 'sshkey-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Workspace SSH Key Assignment' {
        It 'Step 1: Assign SSH key to workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = $testWorkspaceId
                        type = 'workspaces'
                        relationships = @{
                            'ssh-key' = @{
                                data = @{
                                    id = 'sshkey-integration-123'
                                    type = 'ssh-keys'
                                }
                            }
                        }
                    }
                }
            }

            $result = Set-TfcWorkspaceSSHKey -Organization $testOrgName `
                -WorkspaceName 'test-workspace' `
                -SSHKeyId 'sshkey-integration-123'

            $result.data.relationships.'ssh-key'.data.id | Should -Be 'sshkey-integration-123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Verify SSH key is assigned' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = $testWorkspaceId
                        relationships = @{
                            'ssh-key' = @{
                                data = @{
                                    id = 'sshkey-integration-123'
                                }
                            }
                        }
                    }
                }
            }

            $workspace = Get-TfcWorkspace -Organization $testOrgName -Name 'test-workspace'

            $workspace.data.relationships.'ssh-key'.data.id | Should -Be 'sshkey-integration-123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Remove SSH key from workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                # First call is Get-TfcWorkspace to get the ID
                if ($Method -eq 'GET' -or -not $Method) {
                    return @{
                        data = @{
                            id = $testWorkspaceId
                        }
                    }
                }
                # Second call is the PATCH to remove SSH key
                return @{
                    data = @{
                        id = $testWorkspaceId
                        relationships = @{
                            'ssh-key' = @{
                                data = $null
                            }
                        }
                    }
                }
            }

            $result = Set-TfcWorkspaceSSHKey -Organization $testOrgName -WorkspaceName 'test-workspace' -SSHKeyId ''

            $result.data.relationships.'ssh-key'.data | Should -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2  # GET + PATCH
        }
    }

    Context 'VCS Integration with SSH Keys' {
        It 'Should use SSH key for private Git repository' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                # First call is Get-TfcWorkspace to get the ID
                if ($Method -eq 'GET' -or -not $Method) {
                    return @{
                        data = @{
                            id = $testWorkspaceId
                        }
                    }
                }
                # Second call is Set SSH key
                return @{
                    data = @{
                        id = $testWorkspaceId
                        relationships = @{
                            'ssh-key' = @{
                                data = @{
                                    id = 'sshkey-integration-123'
                                }
                            }
                        }
                    }
                }
            }

            $result = Set-TfcWorkspaceSSHKey -Organization $testOrgName `
                -WorkspaceName 'test-workspace' `
                -SSHKeyId 'sshkey-integration-123'

            $result.data.relationships.'ssh-key'.data.id | Should -Be 'sshkey-integration-123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2  # GET + PATCH
        }
    }
}


