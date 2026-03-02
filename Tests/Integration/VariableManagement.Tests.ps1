# Integration Test: Variable Management Workflow
# Tests the complete lifecycle of variable sets and workspace variables

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

Describe 'Variable Management Integration Test' -Tag 'Integration', 'Variables' {
    BeforeAll {
        $testOrgName = 'test-org'
        $testWorkspaceId = 'ws-test123'
        $testVariableSetName = "test-varset-$(Get-Random)"
    }

    Context 'Variable Set Lifecycle' {
        It 'Step 1: Create variable set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                $bodyObj = if($Body) { $Body | ConvertFrom-Json } else { $null }
                return @{
                    data = @{
                        id = 'varset-integration-123'
                        type = 'varsets'
                        attributes = @{
                            name = $bodyObj.data.attributes.name
                            description = $bodyObj.data.attributes.description
                            global = $false
                        }
                    }
                }
            }

            $varSet = New-TfcVariableSet -Organization $testOrgName -Name $testVariableSetName -Description "Integration test variable set"

            $varSet.data.id | Should -Be 'varset-integration-123'
            $varSet.data.attributes.name | Should -Be $testVariableSetName
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Add Terraform variable to set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'var-tf-123'
                        type = 'vars'
                        attributes = @{
                            key = 'aws_region'
                            value = 'us-east-1'
                            category = 'terraform'
                            sensitive = $false
                        }
                    }
                }
            }

            $var = New-TfcVariableSetVariable -VariableSetId 'varset-integration-123' `
                -Key 'aws_region' `
                -Value 'us-east-1' `
                -Category 'terraform'

            $var.data.attributes.key | Should -Be 'aws_region'
            $var.data.attributes.category | Should -Be 'terraform'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Add environment variable to set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'var-env-123'
                        type = 'vars'
                        attributes = @{
                            key = 'AWS_ACCESS_KEY_ID'
                            value = 'sensitive-value'
                            category = 'env'
                            sensitive = $true
                        }
                    }
                }
            }

            $envVar = New-TfcVariableSetVariable -VariableSetId 'varset-integration-123' `
                -Key 'AWS_ACCESS_KEY_ID' `
                -Value 'sensitive-value' `
                -Category 'env' `
                -Sensitive $true

            $envVar.data.attributes.category | Should -Be 'env'
            $envVar.data.attributes.sensitive | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Assign variable set to workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'varset-integration-123'
                    }
                }
            }

            $result = Set-TfcVariableSetWorkspace -VariableSetId 'varset-integration-123' -WorkspaceIds @($testWorkspaceId)

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Update variable in set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'var-tf-123'
                        attributes = @{
                            key = 'aws_region'
                            value = 'us-west-2'
                            category = 'terraform'
                        }
                    }
                }
            }

            $updated = Update-TfcVariableSetVariable -VariableSetId 'varset-integration-123' `
                -VariableId 'var-tf-123' `
                -Value 'us-west-2'

            $updated.data.attributes.value | Should -Be 'us-west-2'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 6: Remove variable from set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcVariableSetVariable -VariableSetId 'varset-integration-123' -VariableId 'var-tf-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 7: Unassign variable set from workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'varset-integration-123'
                    }
                }
            }

            $result = Remove-TfcVariableSetWorkspace -VariableSetId 'varset-integration-123' -WorkspaceIds @($testWorkspaceId) -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 8: Delete variable set' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcVariableSet -VariableSetId 'varset-integration-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Workspace Variable Management' {
        It 'Step 1: Create workspace variable' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'var-ws-123'
                        attributes = @{
                            key = 'environment'
                            value = 'development'
                            category = 'terraform'
                        }
                    }
                }
            }

            $var = Set-TfcWorkspaceVariable -WorkspaceId $testWorkspaceId `
                -Key 'environment' `
                -Value 'development' `
                -Category 'terraform'

            $var.data.attributes.key | Should -Be 'environment'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Update workspace variable' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'var-ws-123'
                        attributes = @{
                            key = 'environment'
                            value = 'production'
                            category = 'terraform'
                        }
                    }
                }
            }

            $updated = Update-TfcWorkspaceVariable -WorkspaceId $testWorkspaceId `
                -Key 'environment' `
                -Value 'production' `
                -Category 'terraform'

            $updated.data.attributes.value | Should -Be 'production'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: List workspace variables' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'var-ws-123'
                            attributes = @{
                                key = 'environment'
                                value = 'production'
                                category = 'terraform'
                            }
                        }
                    )
                }
            }

            $vars = Get-TfcWorkspaceVariable -WorkspaceId $testWorkspaceId

            $vars.data.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Delete workspace variable' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                # Mock GET for variable lookup (also handle $null Method which defaults to GET)
                if ((-not $Method) -or ($Method -eq 'GET')) {
                    return @{
                        data = @(
                            @{
                                id = 'var-ws-123'
                                attributes = @{
                                    key = 'environment'
                                    value = 'production'
                                    category = 'terraform'
                                }
                            }
                        )
                    }
                }
                # Mock DELETE for actual deletion
                return $null
            }

            $result = Remove-TfcWorkspaceVariable -WorkspaceId $testWorkspaceId -Key 'environment' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2  # GET + DELETE
        }
    }

    Context 'HCL Variables' {
        It 'Should handle HCL-formatted variables' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'var-hcl-123'
                        attributes = @{
                            key = 'subnet_cidrs'
                            value = '["10.0.1.0/24", "10.0.2.0/24"]'
                            category = 'terraform'
                            hcl = $true
                        }
                    }
                }
            }

            $hclVar = Set-TfcWorkspaceVariable -WorkspaceId $testWorkspaceId `
                -Key 'subnet_cidrs' `
                -Value '["10.0.1.0/24", "10.0.2.0/24"]' `
                -Category 'terraform' `
                -Hcl

            $hclVar.data.attributes.hcl | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Sensitive Variables' {
        It 'Should mark sensitive variables correctly' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'var-sensitive-123'
                        attributes = @{
                            key = 'database_password'
                            value = $null
                            category = 'terraform'
                            sensitive = $true
                        }
                    }
                }
            }

            $sensitiveVar = Set-TfcWorkspaceVariable -WorkspaceId $testWorkspaceId `
                -Key 'database_password' `
                -Value 'super-secret' `
                -Category 'terraform' `
                -Sensitive

            $sensitiveVar.data.attributes.sensitive | Should -BeTrue
            # Value should be null in response for sensitive variables
            $sensitiveVar.data.attributes.value | Should -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


