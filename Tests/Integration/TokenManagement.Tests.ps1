# Integration Test: Token Management
# Tests organization, team, and user token operations

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

Describe 'Token Management Integration Test' -Tag 'Integration', 'Tokens' {
    BeforeAll {
        $testOrgName = 'test-org'
    }

    Context 'Organization Token Management' {
        It 'Step 1: Create organization token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'at-org-123'
                        type = 'authentication-tokens'
                        attributes = @{
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            'last-used-at' = $null
                            description = 'Automation token'
                            token = 'ZBt1a...'
                        }
                    }
                }
            }

            $token = New-TfcOrganizationToken -Organization $testOrgName `
                -ExpiredAt ((Get-Date).AddDays(30))

            $token.data.attributes.token | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Delete organization token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcOrganizationToken -Organization $testOrgName -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Team Token Management' {
        It 'Step 1: Create team token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'at-team-456'
                        type = 'authentication-tokens'
                        attributes = @{
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            'last-used-at' = $null
                            token = 'XYz2b...'
                        }
                    }
                }
            }

            $token = New-TfcTeamToken -TeamId 'team-123' `
                -ExpiredAt ((Get-Date).AddDays(60))

            $token.data.attributes.token | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Delete team token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcTeamToken -TeamId 'team-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'User Token Management' {
        It 'Step 1: List user tokens' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'at-user-789'
                            type = 'authentication-tokens'
                            attributes = @{
                                'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                                'last-used-at' = (Get-Date).AddHours(-2).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                                description = 'CLI token'
                            }
                        }
                    )
                }
            }

            $tokens = Get-TfcUserToken

            $tokens.data.Count | Should -BeGreaterThan 0
            $tokens.data[0].attributes.description | Should -Be 'CLI token'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Create user token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'at-user-new-123'
                        type = 'authentication-tokens'
                        attributes = @{
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            description = 'API token'
                            token = 'AbC3d...'
                        }
                    }
                }
            }

            $token = New-TfcUserToken -Description 'API token' `
                -ExpiredAt ((Get-Date).AddDays(90))

            $token.data.attributes.description | Should -Be 'API token'
            $token.data.attributes.token | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Get user token details' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'at-user-789'
                            attributes = @{
                                description = 'CLI token'
                                'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                                'last-used-at' = (Get-Date).AddHours(-2).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                                'expired-at' = $null
                            }
                        }
                    )
                }
            }

            $tokens = Get-TfcUserToken

            $tokens.data[0].attributes.description | Should -Be 'CLI token'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Delete user token' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $null
            }

            $result = Remove-TfcUserToken -TokenId 'at-user-new-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Token Expiration' {
        It 'Should create token with expiration date' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'at-expiring-123'
                        attributes = @{
                            'created-at' = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            'expired-at' = (Get-Date).AddDays(7).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            token = 'Exp4e...'
                        }
                    }
                }
            }

            $expirationDate = (Get-Date).AddDays(7)
            $token = New-TfcUserToken -Description 'Short-lived token' `
                -ExpiredAt $expirationDate

            $token.data.attributes.'expired-at' | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should verify token has not expired' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'at-check-123'
                            attributes = @{
                                'expired-at' = (Get-Date).AddDays(30).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                            }
                        }
                    )
                }
            }

            $tokens = Get-TfcUserToken
            $expirationDate = [DateTime]::Parse($tokens.data[0].attributes.'expired-at')

            $expirationDate | Should -BeGreaterThan (Get-Date)
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


