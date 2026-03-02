# Integration Test: Team Access Management
# Tests team creation, member management, and workspace access control

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

Describe 'Team Access Management Integration Test' -Tag 'Integration', 'Teams', 'RBAC' {
    BeforeAll {
        $testOrgName = 'test-org'
        $testWorkspaceId = 'ws-test123'
        $testTeamName = "test-team-$(Get-Random)"
    }

    Context 'Team Lifecycle' {
        It 'Step 1: Create team' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                $bodyObj = if($Body) { $Body | ConvertFrom-Json } else { $null }
                return @{
                    data = @{
                        id = 'team-integration-123'
                        type = 'teams'
                        attributes = @{
                            name = $bodyObj.data.attributes.name
                            visibility = $bodyObj.data.attributes.visibility
                            'organization-access' = @{}
                        }
                    }
                }
            }

            $team = New-TfcTeam -Organization $testOrgName -Name $testTeamName -Visibility 'organization'

            $team.data.id | Should -Be 'team-integration-123'
            $team.data.attributes.name | Should -Be $testTeamName
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Update team' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'team-integration-123'
                        attributes = @{
                            name = "$testTeamName-updated"
                            visibility = 'organization'
                        }
                    }
                }
            }

            $updated = Update-TfcTeam -TeamId 'team-integration-123' -Name "$testTeamName-updated"

            $updated.data.attributes.name | Should -BeLike "*-updated"
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Add team members' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Add-TfcTeamMember -TeamId 'team-integration-123' `
                -OrganizationMembershipIds @('ou-member-123')

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: List team members' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'ou-member-123'
                            attributes = @{
                                email = 'user@example.com'
                                status = 'active'
                            }
                        }
                    )
                }
            }

            $members = Get-TfcTeamMember -TeamId 'team-integration-123'

            $members.data.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Remove team member' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcTeamMember -TeamId 'team-integration-123' `
                -OrganizationMembershipIds @('ou-member-123') -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 6: Delete team' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcTeam -TeamId 'team-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Workspace Access Management' {
        It 'Step 1: Grant read access' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'tws-read-123'
                        attributes = @{
                            access = 'read'
                        }
                        relationships = @{
                            team = @{ data = @{ id = 'team-integration-123' } }
                            workspace = @{ data = @{ id = $testWorkspaceId } }
                        }
                    }
                }
            }

            $access = Add-TfcWorkspaceTeamAccess -TeamId 'team-integration-123' `
                -WorkspaceId $testWorkspaceId `
                -Access 'read'

            $access.data.attributes.access | Should -Be 'read'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Upgrade to plan access' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'tws-read-123'
                        attributes = @{
                            access = 'plan'
                        }
                    }
                }
            }

            $updated = Update-TfcWorkspaceTeamAccess -TeamWorkspaceId 'tws-read-123' `
                -Access 'plan'

            $updated.data.attributes.access | Should -Be 'plan'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Upgrade to write access' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'tws-read-123'
                        attributes = @{
                            access = 'write'
                        }
                    }
                }
            }

            $updated = Update-TfcWorkspaceTeamAccess -TeamWorkspaceId 'tws-read-123' `
                -Access 'write'

            $updated.data.attributes.access | Should -Be 'write'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Upgrade to admin access' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'tws-read-123'
                        attributes = @{
                            access = 'admin'
                        }
                    }
                }
            }

            $updated = Update-TfcWorkspaceTeamAccess -TeamWorkspaceId 'tws-read-123' `
                -Access 'admin'

            $updated.data.attributes.access | Should -Be 'admin'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: List workspace access' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'tws-read-123'
                        attributes = @{
                            access = 'admin'
                        }
                    }
                }
            }

            $accessList = Show-TfcWorkspaceTeamAccess -TeamWorkspaceId 'tws-read-123'

            $accessList.data.id | Should -Be 'tws-read-123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 6: Remove workspace access' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcWorkspaceTeamAccess -TeamWorkspaceId 'tws-read-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Project Access Management' {
        It 'Should grant project access to team' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'tprj-123'
                        type = 'team-projects'
                        attributes = @{
                            access = 'write'
                            'runs-access' = 'apply'
                            'variables-access' = 'write'
                        }
                    }
                }
            }

            $projectAccess = Add-TfcProjectTeamAccess -ProjectId 'prj-test123' `
                -TeamId 'team-integration-123' `
                -Access 'write'

            $projectAccess.data.attributes.access | Should -Be 'write'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should update project access level' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'tprj-123'
                        attributes = @{
                            access = 'admin'
                        }
                    }
                }
            }

            $updated = Update-TfcProjectTeamAccess -TeamProjectId 'tprj-123' `
                -Access 'admin'

            $updated.data.attributes.access | Should -Be 'admin'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should remove project access' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcProjectTeamAccess -TeamProjectId 'tprj-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Organization Membership' {
        It 'Should list organization members' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'ou-member-123'
                            attributes = @{
                                email = 'user@example.com'
                                status = 'active'
                            }
                        }
                    )
                }
            }

            $members = Get-TfcOrganizationMembership -Organization $testOrgName

            $members.data.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should remove organization member' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcOrganizationMembership -MembershipId 'ou-member-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


