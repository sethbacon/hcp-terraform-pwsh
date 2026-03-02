# Integration Test: Advanced Run Operations
# Tests run lifecycle, plan/apply operations, cost estimation, and comments

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

Describe 'Advanced Run Operations Integration Test' -Tag 'Integration', 'Run' {
    BeforeAll {
        $testOrgName = 'test-org'
        $testWorkspace = 'test-workspace'
    }

    Context 'Cost Estimation' {
        It 'Step 1: Get cost estimate for run' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                # First call gets the run
                if ($Uri -like '*/runs/*' -and $Uri -notlike '*/cost-estimate') {
                    return @{
                        data = @{
                            id = 'run-123'
                            relationships = @{
                                'cost-estimate' = @{
                                    data = @{ id = 'ce-123' }
                                }
                            }
                        }
                    }
                }
                # Second call gets the cost estimate
                return @{
                    data = @{
                        id = 'ce-123'
                        type = 'cost-estimates'
                        attributes = @{
                            status = 'finished'
                            'matched-resources-count' = 5
                            'unmatched-resources-count' = 0
                            'resources-count' = 5
                            'delta-monthly-cost' = '150.00'
                        }
                    }
                }
            }

            $costEst = Get-TfcCostEstimate -RunId 'run-123'

            $costEst.data.attributes.'delta-monthly-cost' | Should -Be '150.00'
            $costEst.data.attributes.status | Should -Be 'finished'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2  # GET run + GET cost estimate
        }
    }

    Context 'Plan Export' {
        It 'Step 1: Export plan data' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'pe-123'
                        type = 'plan-exports'
                        attributes = @{
                            status = 'finished'
                            'data-type' = 'sentinel-mock-bundle-v0'
                        }
                        links = @{
                            download = 'https://app.terraform.io/api/v2/plan-exports/pe-123/download'
                        }
                    }
                }
            }

            $export = New-TfcPlanExport -PlanId 'plan-456' `
                -DataType 'sentinel-mock-bundle-v0'

            $export.data.attributes.status | Should -Be 'finished'
            $export.data.links.download | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Get plan export details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'pe-123'
                        attributes = @{
                            status = 'finished'
                            'data-type' = 'sentinel-mock-bundle-v0'
                        }
                    }
                }
            }

            $details = Get-TfcPlanExport -PlanExportId 'pe-123'

            $details.data.attributes.status | Should -Be 'finished'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Get plan export with download URL' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'pe-123'
                        attributes = @{
                            status = 'finished'
                            'download-url' = 'https://app.terraform.io/api/v2/plan-exports/pe-123/download'
                        }
                    }
                }
            }

            $export = Get-TfcPlanExport -PlanExportId 'pe-123'

            $export.data.attributes.'download-url' | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Apply Management' {
        It 'Step 1: Get apply details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)
                # First call: GET run to get apply relationship
                if ($Uri -like '*/runs/*') {
                    return @{
                        data = @{
                            id = 'run-123'
                            relationships = @{
                                apply = @{
                                    data = @{
                                        id = 'apply-123'
                                    }
                                }
                            }
                        }
                    }
                }
                # Second call: GET apply
                return @{
                    data = @{
                        id = 'apply-123'
                        type = 'applies'
                        attributes = @{
                            status = 'finished'
                            'resource-additions' = 3
                            'resource-changes' = 1
                            'resource-destructions' = 0
                        }
                    }
                }
            }

            $apply = Get-TfcApply -RunId 'run-123'

            $apply.data.attributes.status | Should -Be 'finished'
            $apply.data.attributes.'resource-additions' | Should -Be 3
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2
        }

        It 'Step 2: Get apply logs' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'apply-123'
                        attributes = @{
                            'log-read-url' = 'https://archivist.terraform.io/...'
                        }
                    }
                }
            }

            Mock Invoke-WebRequest -ModuleName TerraformCloud {
                return @{
                    Content = "Terraform apply complete! Resources: 3 added, 1 changed, 0 destroyed."
                }
            }

            $logs = Get-TfcApplyLog -ApplyId 'apply-123'

            $logs | Should -Match 'apply complete'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Run Comments' {
        It 'Step 1: List run comments' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'rc-123'
                            attributes = @{
                                body = 'Approved for production'
                            }
                        }
                    )
                }
            }

            $comments = Get-TfcComment -RunId 'run-123'

            $comments.data.Count | Should -Be 1
            $comments.data[0].attributes.body | Should -Be 'Approved for production'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Add run comment' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'rc-new-456'
                        attributes = @{
                            body = 'Ready to apply'
                        }
                    }
                }
            }

            $comment = New-TfcComment -RunId 'run-123' `
                -Body 'Ready to apply'

            $comment.data.attributes.body | Should -Be 'Ready to apply'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Run Priority and Targeting' {
        It 'Should create run with target resources' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'run-targeted-123'
                        attributes = @{
                            'target-addrs' = @('module.vpc', 'aws_instance.web')
                        }
                    }
                }
            }

            $run = New-TfcRun -WorkspaceId 'ws-123' `
                -Message 'Targeted run' `
                -TargetAddrs @('module.vpc', 'aws_instance.web')

            $run.data.attributes.'target-addrs'.Count | Should -Be 2
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Configuration Version from GitHub' {
        It 'Should trigger run from GitHub webhook' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'run-vcs-123'
                        attributes = @{
                            status = 'pending'
                            source = 'tfe-api'
                        }
                        relationships = @{
                            'configuration-version' = @{
                                data = @{
                                    id = 'cv-github-456'
                                }
                            }
                        }
                    }
                }
            }

            $run = New-TfcRun -WorkspaceId 'ws-vcs-123' `
                -Message 'VCS webhook trigger'

            $run.data.relationships.'configuration-version'.data.id | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


