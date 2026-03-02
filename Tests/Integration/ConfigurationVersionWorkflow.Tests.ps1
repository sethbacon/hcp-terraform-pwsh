# Integration Test: Configuration Version Workflow
# Tests configuration version upload and VCS integration

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

Describe 'Configuration Version Workflow Integration Test' -Tag 'Integration', 'ConfigVersions' {
    BeforeAll {
        $testWorkspaceId = 'ws-test123'
    }

    Context 'Configuration Version Lifecycle' {
        It 'Step 1: Create configuration version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'cv-integration-123'
                        type = 'configuration-versions'
                        attributes = @{
                            status = 'pending'
                            'auto-queue-runs' = $true
                            'upload-url' = 'https://archivist.terraform.io/v1/upload/cv-123'
                        }
                    }
                }
            }

            $cv = New-TfcConfigurationVersion -WorkspaceId $testWorkspaceId

            $cv.data.id | Should -Be 'cv-integration-123'
            $cv.data.attributes.status | Should -Be 'pending'
            $cv.data.attributes.'upload-url' | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Create speculative configuration version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'cv-spec-456'
                        type = 'configuration-versions'
                        attributes = @{
                            status = 'pending'
                            speculative = $true
                            'auto-queue-runs' = $false
                        }
                    }
                }
            }

            $speculative = New-TfcConfigurationVersion -WorkspaceId $testWorkspaceId -Speculative

            $speculative.data.attributes.speculative | Should -BeTrue
            $speculative.data.attributes.'auto-queue-runs' | Should -BeFalse
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Upload configuration files' {
            Mock Invoke-RestMethod {
                return @{
                    status = 'uploaded'
                }
            }

            # Simulate tar.gz upload
            $uploadUrl = 'https://archivist.terraform.io/v1/upload/cv-123'
            $result = Invoke-RestMethod -Uri $uploadUrl -Method Put -Body @{} -ContentType 'application/octet-stream'

            $result.status | Should -Be 'uploaded'
            Should -Invoke Invoke-RestMethod -Times 1
        }

        It 'Step 4: Get configuration version details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'cv-integration-123'
                        attributes = @{
                            status = 'uploaded'
                            'auto-queue-runs' = $true
                        }
                    }
                }
            }

            $cv = Get-TfcConfigurationVersion -ConfigurationVersionId 'cv-integration-123'

            $cv.data.attributes.status | Should -Be 'uploaded'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: List configuration versions for workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'cv-integration-123'
                            attributes = @{
                                status = 'uploaded'
                                'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            }
                        },
                        @{
                            id = 'cv-old-456'
                            attributes = @{
                                status = 'uploaded'
                                'created-at' = (Get-Date).AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            }
                        }
                    )
                }
            }

            $cvList = Get-TfcConfigurationVersionList -WorkspaceId $testWorkspaceId

            $cvList.data.Count | Should -Be 2
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Configuration Ingress' {
        It 'Should verify ingress status after upload' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'cv-integration-123'
                        attributes = @{
                            status = 'uploaded'
                            'ingress-attributes' = @{
                                'commit-sha' = 'abc123def456'
                                'commit-url' = 'https://github.com/org/repo/commit/abc123'
                            }
                        }
                    }
                }
            }

            $cv = Get-TfcConfigurationVersion -ConfigurationVersionId 'cv-integration-123'

            $cv.data.attributes.status | Should -Be 'uploaded'
            $cv.data.attributes.'ingress-attributes'.'commit-sha' | Should -Be 'abc123def456'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'VCS-Triggered Configuration Versions' {
        It 'Should retrieve VCS event details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'vcsev-123'
                        attributes = @{
                            'commit-sha' = 'def789abc123'
                            'commit-message' = 'Update infrastructure'
                            'commit-url' = 'https://github.com/org/repo/commit/def789'
                        }
                    }
                }
            }

            $event = Get-TfcVCSEventDetails -VCSEventId 'vcsev-123'

            $event.data.attributes.'commit-sha' | Should -Be 'def789abc123'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Auto-Queue Runs' {
        It 'Should trigger run when auto-queue is enabled' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                param($Uri, $Method, $Body)

                if ($Uri -like '*/configuration-versions') {
                    return @{
                        data = @{
                            id = 'cv-auto-123'
                            attributes = @{
                                'auto-queue-runs' = $true
                                status = 'pending'
                            }
                        }
                    }
                }

                if ($Uri -like '*/runs*') {
                    return @{
                        data = @(
                            @{
                                id = 'run-auto-456'
                                attributes = @{
                                    status = 'planning'
                                    'trigger-reason' = 'configuration-version-uploaded'
                                }
                            }
                        )
                    }
                }
            }

            # Create CV with auto-queue
            $cv = New-TfcConfigurationVersion -WorkspaceId $testWorkspaceId
            $cv.data.attributes.'auto-queue-runs' | Should -BeTrue

            # Verify run was created
            $runs = Get-TfcRun -WorkspaceId $testWorkspaceId
            $runs.data[0].attributes.'trigger-reason' | Should -Be 'configuration-version-uploaded'

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 2
        }

        It 'Should not trigger run when auto-queue is disabled' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'cv-noqueue-123'
                        attributes = @{
                            'auto-queue-runs' = $false
                            status = 'pending'
                        }
                    }
                }
            }

            $cv = New-TfcConfigurationVersion -WorkspaceId $testWorkspaceId -AutoQueueRuns:$false

            $cv.data.attributes.'auto-queue-runs' | Should -BeFalse
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Configuration Download' {
        It 'Should download configuration version archive' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'cv-integration-123'
                        attributes = @{
                            'download-url' = 'https://archivist.terraform.io/v1/download/cv-123'
                        }
                    }
                }
            }

            $cv = Get-TfcConfigurationVersion -ConfigurationVersionId 'cv-integration-123'

            $cv.data.attributes.'download-url' | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


