BeforeAll {
    $helpersPath = Join-Path $PSScriptRoot '..' '..' 'Helpers' 'TestHelpers.psm1'
    Import-Module $helpersPath -Force

    $mocksPath = Join-Path $PSScriptRoot '..' '..' 'Mocks' 'TfcMocks.psm1'
    Import-Module $mocksPath -Force

    $modulePath = Join-Path $PSScriptRoot '..' '..' '..' 'Output' 'TerraformCloud' 'TerraformCloud.psd1'
    Import-Module $modulePath -Force

    $env:TFE_TOKEN = "test-token-12345"
}

AfterAll {
    Remove-Module TerraformCloud -Force -ErrorAction SilentlyContinue
    Remove-Module TestHelpers -Force -ErrorAction SilentlyContinue
    Remove-Module TfcMocks -Force -ErrorAction SilentlyContinue
}

Describe 'New-TfcOAuthClient' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            $command = Get-Command New-TfcOAuthClient
            $command.Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have ServiceProvider parameter as mandatory' {
            $command = Get-Command New-TfcOAuthClient
            $command.Parameters['ServiceProvider'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have HttpUrl parameter as mandatory' {
            $command = Get-Command New-TfcOAuthClient
            $command.Parameters['HttpUrl'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have ApiUrl parameter as mandatory' {
            $command = Get-Command New-TfcOAuthClient
            $command.Parameters['ApiUrl'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have ServiceProvider with ValidateSet including common providers' {
            $command = Get-Command New-TfcOAuthClient
            $validateSet = $command.Parameters['ServiceProvider'].Attributes.Where({$_.TypeId.Name -eq 'ValidateSetAttribute'})
            $validateSet.ValidValues | Should -Contain 'github'
            $validateSet.ValidValues | Should -Contain 'gitlab_hosted'
            $validateSet.ValidValues | Should -Contain 'bitbucket_hosted'
            $validateSet.ValidValues | Should -Contain 'azure_devops_services'
        }

        It 'Should support ShouldProcess' {
            $command = Get-Command New-TfcOAuthClient
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }
    }

    Context 'Creating OAuth client' {
        It 'Should call correct API endpoint with POST method' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockOAuthClient }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'github' `
                -HttpUrl 'https://github.com' -ApiUrl 'https://api.github.com' -Confirm:$false

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/organizations/test-org/oauth-clients' -and
                $Method -eq 'Post'
            }
        }

        It 'Should include service-provider in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'service-provider' | Should -Be 'github'
                return @{ data = Get-MockOAuthClient }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'github' `
                -HttpUrl 'https://github.com' -ApiUrl 'https://api.github.com' -Confirm:$false
        }

        It 'Should include http-url in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'http-url' | Should -Be 'https://github.com'
                return @{ data = Get-MockOAuthClient }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'github' `
                -HttpUrl 'https://github.com' -ApiUrl 'https://api.github.com' -Confirm:$false
        }

        It 'Should include api-url in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'api-url' | Should -Be 'https://api.github.com'
                return @{ data = Get-MockOAuthClient }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'github' `
                -HttpUrl 'https://github.com' -ApiUrl 'https://api.github.com' -Confirm:$false
        }

        It 'Should include Key when provided' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.key | Should -Be 'client-key-123'
                return @{ data = Get-MockOAuthClient }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'github' `
                -HttpUrl 'https://github.com' -ApiUrl 'https://api.github.com' `
                -Key 'client-key-123' -Confirm:$false
        }

        It 'Should include Secret when provided' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.secret | Should -Be 'client-secret-xyz'
                return @{ data = Get-MockOAuthClient }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'github' `
                -HttpUrl 'https://github.com' -ApiUrl 'https://api.github.com' `
                -Secret 'client-secret-xyz' -Confirm:$false
        }

        It 'Should include Name when provided' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.name | Should -Be 'My GitHub Connection'
                return @{ data = Get-MockOAuthClient }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'github' `
                -HttpUrl 'https://github.com' -ApiUrl 'https://api.github.com' `
                -Name 'My GitHub Connection' -Confirm:$false
        }
    }

    Context 'Different service providers' {
        It 'Should work with GitLab' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'service-provider' | Should -Be 'gitlab_hosted'
                return @{ data = Get-MockOAuthClient -ServiceProvider 'gitlab_hosted' }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'gitlab_hosted' `
                -HttpUrl 'https://gitlab.com' -ApiUrl 'https://gitlab.com/api/v4' -Confirm:$false
        }

        It 'Should work with Azure DevOps' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'service-provider' | Should -Be 'azure_devops_services'
                return @{ data = Get-MockOAuthClient -ServiceProvider 'azure_devops_services' }
            }

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'azure_devops_services' `
                -HttpUrl 'https://dev.azure.com' -ApiUrl 'https://dev.azure.com' -Confirm:$false
        }
    }

    Context 'ShouldProcess support' {
        It 'Should not create OAuth client when WhatIf is specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud

            New-TfcOAuthClient -Organization 'test-org' -ServiceProvider 'github' `
                -HttpUrl 'https://github.com' -ApiUrl 'https://api.github.com' -WhatIf

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
}
