# Integration Test: Admin Operations
# Tests organization settings, SAML, and admin-level operations

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

Describe 'Admin Operations Integration Test' -Tag 'Integration', 'Admin' {
    BeforeAll {
        $testOrgName = 'test-org'
    }

    Context 'Organization Settings' {
        It 'Step 1: Get organization details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'org-123'
                        type = 'organizations'
                        attributes = @{
                            name = 'test-org'
                            email = 'admin@test-org.com'
                            'session-timeout' = 20160
                            'session-remember' = 20160
                            'collaborator-auth-policy' = 'password'
                            'cost-estimation-enabled' = $true
                        }
                    }
                }
            }

            $org = Get-TfcOrganization -Name $testOrgName

            $org.data.attributes.name | Should -Be 'test-org'
            $org.data.attributes.'cost-estimation-enabled' | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Update organization settings' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'org-123'
                        attributes = @{
                            email = 'newemail@test-org.com'
                            'session-timeout' = 10080
                        }
                    }
                }
            }

            $updated = Update-TfcOrganization -Organization $testOrgName `
                -Email 'newemail@test-org.com' `
                -SessionTimeout 10080

            $updated.data.attributes.email | Should -Be 'newemail@test-org.com'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Update collaborator authentication policy' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'org-123'
                        attributes = @{
                            'collaborator-auth-policy' = 'two_factor_mandatory'
                        }
                    }
                }
            }

            $updated = Update-TfcOrganization -Organization $testOrgName `
                -CollaboratorAuthPolicy 'two_factor_mandatory'

            $updated.data.attributes.'collaborator-auth-policy' | Should -Be 'two_factor_mandatory'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Organization Membership' {
        It 'Step 1: List organization memberships' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'ou-123'
                            type = 'organization-memberships'
                            attributes = @{
                                email = 'user1@test.com'
                                status = 'active'
                            }
                        }
                    )
                }
            }

            $members = Get-TfcOrganizationMembership -Organization $testOrgName

            $members.data.Count | Should -BeGreaterThan 0
            $members.data[0].attributes.status | Should -Be 'active'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Invite user to organization' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ou-new-456'
                        attributes = @{
                            email = 'newuser@test.com'
                            status = 'invited'
                        }
                    }
                }
            }

            $invite = Invoke-TfcOrganizationMembershipInvite -Organization $testOrgName `
                -Email 'newuser@test.com'

            $invite.data.attributes.status | Should -Be 'invited'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Remove organization membership' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $true
            }

            $result = Remove-TfcOrganizationMembership -MembershipId 'ou-new-456' -Confirm:$false

            if ($result -is [array]) {
                $result = $result[-1]
            }

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'SAML Settings' {
        It 'Step 1: Get SAML settings' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'saml-123'
                        type = 'saml-settings'
                        attributes = @{
                            enabled = $true
                            'idp-cert' = '-----BEGIN CERTIFICATE-----...'
                            'slo-endpoint-url' = 'https://idp.test.com/slo'
                            'sso-endpoint-url' = 'https://idp.test.com/sso'
                        }
                    }
                }
            }

            $saml = Get-TfcSAMLSettings -Organization $testOrgName

            $saml.data.attributes.enabled | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Update SAML settings' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'saml-123'
                        attributes = @{
                            enabled = $true
                            'slo-endpoint-url' = 'https://newidp.test.com/slo'
                        }
                    }
                }
            }

            $updated = Update-TfcSAMLSettings -OrganizationName $testOrgName `
                -SLOEndpoint 'https://newidp.test.com/slo' `
                -Confirm:$false

            $updated.data.attributes.'slo-endpoint-url' | Should -Be 'https://newidp.test.com/slo'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Revoke SAML previous token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        attributes = @{
                            'previous-token-revoked-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        }
                    }
                }
            }

            $result = Revoke-TfcSAMLSettings -Organization $testOrgName -Confirm:$false

            $result.data.attributes.'previous-token-revoked-at' | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Organization Entitlements' {
        It 'Should get organization entitlements' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'ent-123'
                        type = 'entitlement-sets'
                        attributes = @{
                            'state-storage' = $true
                            operations = $true
                            'private-module-registry' = $true
                            'sentinel' = $true
                            'cost-estimation' = $true
                            'configuration-designer' = $false
                        }
                    }
                }
            }

            $entitlements = Get-TfcOrganizationEntitlements -Organization $testOrgName

            $entitlements.data.attributes.operations | Should -BeTrue
            $entitlements.data.attributes.sentinel | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Admin User Management' {
        It 'Step 1: List all users (admin)' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'user-123'
                            type = 'users'
                            attributes = @{
                                username = 'admin-user'
                                email = 'admin@test.com'
                                'is-site-admin' = $true
                            }
                        }
                    )
                }
            }

            $users = Get-TfcAdminUser

            $users.data.Count | Should -BeGreaterThan 0
            $users.data[0].attributes.'is-site-admin' | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Grant admin privileges to user' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'user-456'
                        attributes = @{
                            'is-site-admin' = $true
                        }
                    }
                }
            }

            $updated = Grant-TfcAdminPrivilege -UserId 'user-456' -Confirm:$false

            $updated.data.attributes.'is-site-admin' | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Suspend user (admin)' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'user-789'
                        attributes = @{
                            'is-suspended' = $true
                        }
                    }
                }
            }

            $suspended = Suspend-TfcUser -UserId 'user-789' -Confirm:$false

            $suspended.data.attributes.'is-suspended' | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Unsuspend user (admin)' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'user-789'
                        attributes = @{
                            'is-suspended' = $false
                        }
                    }
                }
            }

            $unsuspended = Resume-TfcUser -UserId 'user-789' -Confirm:$false

            $unsuspended.data.attributes.'is-suspended' | Should -BeFalse
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


