# Integration Test: Registry Management
# Tests private registry module and provider operations

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

Describe 'Registry Management Integration Test' -Tag 'Integration', 'Registry' {
    BeforeAll {
        $testOrgName = 'test-org'
    }

    Context 'Private Registry Module Management' {
        It 'Step 1: List registry modules' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'mod-123'
                            type = 'registry-modules'
                            attributes = @{
                                name = 'vpc'
                                provider = 'aws'
                                namespace = 'test-org'
                                'registry-name' = 'private'
                            }
                        }
                    )
                }
            }

            $modules = Get-TfcRegistryModule -Organization $testOrgName

            $modules.data.Count | Should -BeGreaterThan 0
            $modules.data[0].attributes.name | Should -Be 'vpc'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Create registry module' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'mod-new-456'
                        attributes = @{
                            name = 's3-bucket'
                            provider = 'aws'
                            namespace = 'test-org'
                        }
                    }
                }
            }

            $module = New-TfcRegistryModule -Organization $testOrgName `
                -VcsRepoIdentifier 'org/s3-bucket' `
                -OAuthTokenId 'ot-123'

            $module.data.attributes.name | Should -Be 's3-bucket'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Get module details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'mod-123'
                        attributes = @{
                            name = 'vpc'
                            provider = 'aws'
                            namespace = 'test-org'
                            'version-statuses' = @(
                                @{ version = '1.0.0'; status = 'ok' }
                                @{ version = '1.1.0'; status = 'ok' }
                            )
                        }
                    }
                }
            }

            $module = Get-TfcRegistryModule -Organization $testOrgName

            $module.data.attributes.'version-statuses'.Count | Should -BeGreaterThan 0
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Create module version from VCS' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'modver-789'
                        attributes = @{
                            version = '1.2.0'
                            status = 'pending'
                        }
                    }
                }
            }

            $version = New-TfcRegistryModuleVersion -OrganizationName $testOrgName `
                -RegistryName 'private' `
                -Namespace $testOrgName `
                -Name 'vpc' `
                -Provider 'aws' `
                -Version 'v1.2.0'

            $version.data.attributes.version | Should -Be '1.2.0'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Delete registry module' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $true
            }

            $result = Remove-TfcRegistryModule -Organization $testOrgName `
                -Name 's3-bucket' `
                -Provider 'aws' `
                -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Private Registry Provider Management' {
        It 'Step 1: List registry providers' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'prov-123'
                            type = 'registry-providers'
                            attributes = @{
                                name = 'custom'
                                namespace = 'test-org'
                                'registry-name' = 'private'
                            }
                        }
                    )
                }
            }

            $providers = Get-TfcRegistryProvider -Organization $testOrgName

            $providers.data.Count | Should -BeGreaterThan 0
            $providers.data[0].attributes.name | Should -Be 'custom'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Create registry provider' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'prov-new-456'
                        attributes = @{
                            name = 'mycloud'
                            namespace = 'test-org'
                        }
                    }
                }
            }

            $provider = New-TfcRegistryProvider -Organization $testOrgName `
                -Name 'mycloud'

            $provider.data.attributes.name | Should -Be 'mycloud'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Get provider details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'prov-123'
                        attributes = @{
                            name = 'custom'
                            namespace = 'test-org'
                            'version-statuses' = @(
                                @{ version = '1.0.0'; status = 'ok' }
                            )
                        }
                    }
                }
            }

            $provider = Get-TfcRegistryProvider -Organization $testOrgName

            $provider.data.attributes.name | Should -Be 'custom'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Create provider version' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'provver-789'
                        attributes = @{
                            version = '1.1.0'
                            'key-id' = 'gpg-key-123'
                            protocols = @('5.0')
                        }
                    }
                }
            }

            $version = New-TfcRegistryProviderVersion -OrganizationName $testOrgName `
                -RegistryName 'private' `
                -Namespace $testOrgName `
                -Name 'custom' `
                -Version '1.0.0' `
                -KeyId 'key-123' `
                -Protocols @('5.0')

            $version.data.attributes.version | Should -Be '1.1.0'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Create provider platform' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'provplat-123'
                        attributes = @{
                            os = 'linux'
                            arch = 'amd64'
                            filename = 'terraform-provider-custom_1.1.0_linux_amd64.zip'
                            shasum = 'abc123...'
                        }
                    }
                }
            }

            $platform = New-TfcRegistryProviderPlatform -OrganizationName $testOrgName `
                -RegistryName 'private' `
                -Namespace $testOrgName `
                -Name 'custom' `
                -Version '1.0.0' `
                -Os 'linux' `
                -Arch 'amd64' `
                -Filename 'terraform-provider-custom_1.0.0_linux_amd64.zip' `
                -Shasum 'abc123'

            $platform.data.attributes.os | Should -Be 'linux'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 6: Delete registry provider' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $true
            }

            $result = Remove-TfcRegistryProvider -Organization $testOrgName `
                -Name 'mycloud' `
                -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Module Version Publishing' {
        It 'Should upload module tarball' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'modver-upload-123'
                        attributes = @{
                            version = '2.0.0'
                            status = 'uploading'
                            'upload-url' = 'https://archivist.terraform.io/upload/...'
                        }
                    }
                }
            }

            $upload = New-TfcRegistryModuleVersion -OrganizationName $testOrgName `
                -RegistryName 'private' `
                -Namespace $testOrgName `
                -Name 'vpc' `
                -Provider 'aws' `
                -Version '2.0.0'

            $upload.data.attributes.'upload-url' | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Provider Version Publishing' {
        It 'Should create provider version with upload links' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'provver-123'
                        attributes = @{
                            version = '1.2.0'
                        }
                        links = @{
                            'shasums-upload' = 'https://archivist.terraform.io/shasums/...'
                            'shasums-sig-upload' = 'https://archivist.terraform.io/sig/...'
                        }
                    }
                }
            }

            $version = New-TfcRegistryProviderVersion -OrganizationName $testOrgName `
                -RegistryName 'private' `
                -Namespace $testOrgName `
                -Name 'custom' `
                -Version '1.2.0' `
                -KeyId 'key-123' `
                -Protocols @('5.0')

            $version.data.links.'shasums-upload' | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


