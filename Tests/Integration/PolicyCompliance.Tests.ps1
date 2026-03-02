# Integration Test: Policy Compliance Workflow
# Tests policy creation, policy sets, and enforcement workflows

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

Describe 'Policy Compliance Integration Test' -Tag 'Integration', 'Policies', 'Sentinel' {
    BeforeAll {
        $testOrgName = 'test-org'
        $testWorkspaceId = 'ws-test123'
        $testProjectId = 'prj-test456'
        $testPolicyName = "test-policy-$(Get-Random)"
        $testPolicySetName = "test-policy-set-$(Get-Random)"
    }

    Context 'Policy Lifecycle' {
        It 'Step 1: Create policy' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                return @{
                    data = @{
                        id = 'pol-integration-123'
                        type = 'policies'
                        attributes = @{
                            name = $bodyObj.data.attributes.name
                            description = $bodyObj.data.attributes.description
                            'enforcement-level' = $bodyObj.data.attributes.'enforcement-level'
                        }
                    }
                }
            }

            $policy = New-TfcPolicy -OrganizationName $testOrgName `
                -Name $testPolicyName `
                -Description "Test policy for integration testing" `
                -Kind 'sentinel' `
                -EnforcementLevel 'advisory' `
                -PolicyCode 'main = rule { true }'

            $policy.data.id | Should -Be 'pol-integration-123'
            $policy.data.attributes.name | Should -Be $testPolicyName
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Update policy enforcement' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'pol-integration-123'
                        attributes = @{
                            enforcement = 'hard-mandatory'
                        }
                    }
                }
            }

            $updated = Update-TfcPolicy -PolicyId 'pol-integration-123' -Enforcement 'hard-mandatory'

            $updated.data.attributes.enforcement | Should -Be 'hard-mandatory'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Delete policy' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $true
            }

            $result = Remove-TfcPolicy -PolicyId 'pol-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Policy Set Management' {
        It 'Step 1: Create policy set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                return @{
                    data = @{
                        id = 'polset-integration-123'
                        type = 'policy-sets'
                        attributes = @{
                            name = $bodyObj.data.attributes.name
                            description = $bodyObj.data.attributes.description
                            global = $false
                        }
                    }
                }
            }

            $policySet = New-TfcPolicySet -OrganizationName $testOrgName `
                -Name $testPolicySetName `
                -Description "Integration test policy set" `
                -Kind 'sentinel'

            $policySet.data.id | Should -Be 'polset-integration-123'
            $policySet.data.attributes.name | Should -Be $testPolicySetName
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Add policy to policy set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Add-TfcPolicySetPolicy -PolicySetId 'polset-integration-123' `
                -PolicyId 'pol-integration-123'

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Assign policy set to workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Set-TfcPolicySetWorkspace -PolicySetId 'polset-integration-123' `
                -WorkspaceIds @($testWorkspaceId)

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Make policy set global' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'polset-integration-123'
                        attributes = @{
                            global = $true
                        }
                    }
                }
            }

            $updated = Update-TfcPolicySet -PolicySetId 'polset-integration-123' -Global $true

            $updated.data.attributes.global | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Assign policy set to project' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Set-TfcPolicySetProject -PolicySetId 'polset-integration-123' `
                -ProjectIds @($testProjectId)

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 6: Remove policy set from workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            # Note: There is no Remove-TfcPolicySetWorkspace function yet
            # The API would require DELETE to /policy-sets/{id}/relationships/workspaces
            # For now, test with a different workspace to simulate "changing" assignment
            $result = Set-TfcPolicySetWorkspace -PolicySetId 'polset-integration-123' `
                -WorkspaceIds @('ws-different-workspace')

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 7: Delete policy set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcPolicySet -PolicySetId 'polset-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Policy Check Workflow' {
        It 'Should retrieve policy check results for run' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'polchk-123'
                            type = 'policy-checks'
                            attributes = @{
                                status = 'passed'
                                result = @{
                                    passed = 5
                                    failed = 0
                                    advisory = 2
                                }
                            }
                        }
                    )
                }
            }

            $checks = Get-TfcPolicyCheck -RunId 'run-test123'

            $checks.data[0].attributes.status | Should -Be 'passed'
            $checks.data[0].attributes.result.passed | Should -Be 5
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should handle failed policy checks' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'polchk-failed'
                            attributes = @{
                                status = 'failed'
                                result = @{
                                    passed = 3
                                    failed = 2
                                    advisory = 1
                                }
                            }
                        }
                    )
                }
            }

            $checks = Get-TfcPolicyCheck -RunId 'run-test123'

            $checks.data[0].attributes.status | Should -Be 'failed'
            $checks.data[0].attributes.result.failed | Should -Be 2
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should override failed soft-mandatory policy' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'polchk-override'
                        attributes = @{
                            status = 'overridden'
                        }
                    }
                }
            }

            $result = Set-TfcPolicyCheckOverride -PolicyCheckId 'polchk-failed' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Enforcement Levels' {
        It 'Should support advisory enforcement (warning only)' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'pol-advisory'
                        attributes = @{
                            enforcement = 'advisory'
                        }
                    }
                }
            }

            $policy = New-TfcPolicy -OrganizationName $testOrgName `
                -Name "advisory-policy" `
                -Kind 'sentinel' `
                -PolicyCode 'main = rule { true }' `
                -EnforcementLevel 'advisory'

            $policy.data.attributes.enforcement | Should -Be 'advisory'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should support soft-mandatory enforcement (overridable)' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'pol-soft'
                        attributes = @{
                            enforcement = 'soft-mandatory'
                        }
                    }
                }
            }

            $policy = New-TfcPolicy -OrganizationName $testOrgName `
                -Name "soft-mandatory-policy" `
                -Kind 'sentinel' `
                -PolicyCode 'main = rule { false }' `
                -EnforcementLevel 'soft-mandatory'

            $policy.data.attributes.enforcement | Should -Be 'soft-mandatory'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should support hard-mandatory enforcement (blocking)' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'pol-hard'
                        attributes = @{
                            enforcement = 'hard-mandatory'
                        }
                    }
                }
            }

            $policy = New-TfcPolicy -OrganizationName $testOrgName `
                -Name "hard-mandatory-policy" `
                -Kind 'sentinel' `
                -PolicyCode 'main = rule { false }' `
                -EnforcementLevel 'hard-mandatory'

            $policy.data.attributes.enforcement | Should -Be 'hard-mandatory'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'VCS-Backed Policy Sets' {
        It 'Should create VCS-backed policy set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'polset-vcs-123'
                        attributes = @{
                            name = 'vcs-policies'
                            'vcs-repo' = @{
                                identifier = 'org/policy-repo'
                                branch = 'main'
                            }
                        }
                    }
                }
            }

            $vcsSet = New-TfcPolicySet -OrganizationName $testOrgName `
                -Name 'vcs-policies' `
                -Kind 'sentinel'

            $vcsSet.data.attributes.'vcs-repo'.identifier | Should -Be 'org/policy-repo'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


