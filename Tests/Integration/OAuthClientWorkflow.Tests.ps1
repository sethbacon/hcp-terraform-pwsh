# Integration Test: OAuth Client Workflow
# Tests OAuth client configuration and VCS provider integration

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

Describe 'OAuth Client Workflow Integration Test' -Tag 'Integration', 'OAuth' {
    BeforeAll {
        $testOrgName = 'test-org'
    }

    Context 'OAuth Client Management' {
        It 'Step 1: List OAuth clients' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'oc-github-123'
                            type = 'oauth-clients'
                            attributes = @{
                                name = 'GitHub OAuth'
                                'service-provider' = 'github'
                                'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            }
                        }
                    )
                }
            }

            $clients = Get-TfcOauthClient -Organization $testOrgName

            $clients.data.Count | Should -BeGreaterThan 0
            $clients.data[0].attributes.'service-provider' | Should -Be 'github'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Get OAuth client details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'oc-github-123'
                        attributes = @{
                            name = 'GitHub OAuth'
                            'service-provider' = 'github'
                            'http-url' = 'https://github.com'
                            'api-url' = 'https://api.github.com'
                        }
                    }
                }
            }

            $client = Get-TfcOAuthClientDetails -OAuthClientId 'oc-github-123'

            $client.data.attributes.'service-provider' | Should -Be 'github'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'OAuth Tokens' {
        It 'Step 1: List OAuth tokens for client' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'ot-token-123'
                            type = 'oauth-tokens'
                            attributes = @{
                                'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                                'service-provider-user' = 'testuser'
                            }
                        }
                    )
                }
            }

            $tokens = Get-TfcOAuthToken -OAuthClientId 'oc-github-123'

            $tokens.data.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Get OAuth token details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ot-token-123'
                        attributes = @{
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            'service-provider-user' = 'testuser'
                            'has-ssh-key' = $true
                        }
                    }
                }
            }

            $token = Get-TfcOAuthTokenDetails -OAuthTokenId 'ot-token-123'

            $token.data.attributes.'service-provider-user' | Should -Be 'testuser'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Update OAuth token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ot-token-123'
                        attributes = @{
                            'ssh-key' = 'ssh-rsa AAAAB3...'
                        }
                    }
                }
            }

            $updated = Update-TfcOAuthToken -OAuthTokenId 'ot-token-123' `
                -SshKey 'ssh-rsa AAAAB3...'

            $updated.data.attributes.'ssh-key' | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Delete OAuth token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $true
            }

            $result = Remove-TfcOAuthToken -OAuthTokenId 'ot-token-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'VCS Integration' {
        It 'Should configure workspace with GitHub' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-vcs-123'
                        attributes = @{
                            'vcs-repo' = @{
                                identifier = 'org/repo'
                                'oauth-token-id' = 'ot-token-123'
                                branch = 'main'
                                'ingress-submodules' = $false
                            }
                        }
                    }
                }
            }

            $workspace = Update-TfcWorkspace -Organization $testOrgName `
                -Name 'test-workspace' `
                -Description 'VCS enabled workspace'

            $workspace.data.attributes.'vcs-repo'.identifier | Should -Be 'org/repo'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should configure workspace with GitLab' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-gitlab-123'
                        attributes = @{
                            'vcs-repo' = @{
                                identifier = 'group/project'
                                'oauth-token-id' = 'ot-gitlab-456'
                                branch = 'develop'
                            }
                        }
                    }
                }
            }

            $workspace = Update-TfcWorkspace -Organization $testOrgName `
                -Name 'test-gitlab-workspace' `
                -Description 'GitLab VCS workspace'

            $workspace.data.attributes.'vcs-repo'.identifier | Should -Be 'group/project'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should configure workspace with Bitbucket' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-bitbucket-123'
                        attributes = @{
                            'vcs-repo' = @{
                                identifier = 'workspace/repo'
                                'oauth-token-id' = 'ot-bitbucket-789'
                                branch = 'master'
                            }
                        }
                    }
                }
            }

            $workspace = Update-TfcWorkspace -Organization $testOrgName `
                -Name 'test-bitbucket-workspace' `
                -Description 'Bitbucket VCS workspace'

            $workspace.data.attributes.'vcs-repo'.identifier | Should -Be 'workspace/repo'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'VCS Repository Settings' {
        It 'Should enable submodule ingress' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-submodules-123'
                        attributes = @{
                            'vcs-repo' = @{
                                identifier = 'org/repo'
                                'ingress-submodules' = $true
                            }
                        }
                    }
                }
            }

            $workspace = Update-TfcWorkspace -Organization $testOrgName `
                -Name 'submodule-workspace' `
                -Description 'Workspace with submodule ingress'

            $workspace.data.attributes.'vcs-repo'.'ingress-submodules' | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should configure tags pattern' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ws-tags-123'
                        attributes = @{
                            'vcs-repo' = @{
                                identifier = 'org/repo'
                                'tags-regex' = '^v\d+\.\d+\.\d+$'
                            }
                        }
                    }
                }
            }

            $workspace = Update-TfcWorkspace -Organization $testOrgName `
                -Name 'tags-workspace' `
                -Description 'Workspace with tags pattern'

            $workspace.data.attributes.'vcs-repo'.'tags-regex' | Should -Be '^v\d+\.\d+\.\d+$'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


