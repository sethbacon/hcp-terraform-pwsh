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

Describe 'New-TfcWorkspace' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            $command = Get-Command New-TfcWorkspace
            $command.Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Name parameter as mandatory' {
            $command = Get-Command New-TfcWorkspace
            $command.Parameters['Name'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have AutoApply as switch parameter' {
            $command = Get-Command New-TfcWorkspace
            $command.Parameters['AutoApply'].SwitchParameter | Should -Be $true
        }

        It 'Should support ShouldProcess' {
            $command = Get-Command New-TfcWorkspace
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }
    }

    Context 'Creating workspace with minimal parameters' {
        It 'Should call correct API endpoint with POST method' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockWorkspace -Name 'new-workspace' }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'new-workspace' -Confirm:$false

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/organizations/test-org/workspaces' -and
                $Method -eq 'Post'
            }
        }

        It 'Should include workspace name in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.name | Should -Be 'test-workspace'
                return @{ data = Get-MockWorkspace -Name 'test-workspace' }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'test-workspace' -Confirm:$false
        }

        It 'Should set default terraform-version to "latest"' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'terraform-version' | Should -Be 'latest'
                return @{ data = Get-MockWorkspace }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'test-workspace' -Confirm:$false
        }

        It 'Should set auto-apply to false by default' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'auto-apply' | Should -Be $false
                return @{ data = Get-MockWorkspace }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'test-workspace' -Confirm:$false
        }
    }

    Context 'Creating workspace with optional parameters' {
        It 'Should include custom TerraformVersion when specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'terraform-version' | Should -Be '1.5.0'
                return @{ data = Get-MockWorkspace }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'test-ws' -TerraformVersion '1.5.0' -Confirm:$false
        }

        It 'Should set auto-apply to true when AutoApply switch is used' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'auto-apply' | Should -Be $true
                return @{ data = Get-MockWorkspace -AutoApply $true }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'test-ws' -AutoApply -Confirm:$false
        }

        It 'Should include WorkingDirectory when specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'working-directory' | Should -Be 'terraform/prod'
                return @{ data = Get-MockWorkspace }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'test-ws' -WorkingDirectory 'terraform/prod' -Confirm:$false
        }

        It 'Should include Description when specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.description | Should -Be 'Test description'
                return @{ data = Get-MockWorkspace }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'test-ws' -Description 'Test description' -Confirm:$false
        }

        It 'Should include VcsRepo when specified' {
            $vcsConfig = @{
                'identifier' = 'org/repo'
                'branch' = 'main'
                'oauth-token-id' = 'ot-12345'
            }

            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.data.attributes.'vcs-repo'.identifier | Should -Be 'org/repo'
                $bodyObj.data.attributes.'vcs-repo'.branch | Should -Be 'main'
                return @{ data = Get-MockWorkspace }
            }

            New-TfcWorkspace -Organization 'test-org' -Name 'test-ws' -VcsRepo $vcsConfig -Confirm:$false
        }
    }

    Context 'ShouldProcess support' {
        It 'Should not create workspace when WhatIf is specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud

            New-TfcWorkspace -Organization 'test-org' -Name 'test-ws' -WhatIf

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }

        It 'Should return workspace data on successful creation' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockWorkspace -Name 'created-workspace' }
            }

            $result = New-TfcWorkspace -Organization 'test-org' -Name 'created-workspace' -Confirm:$false

            $result.data.type | Should -Be 'workspaces'
            $result.data.attributes.name | Should -Be 'created-workspace'
        }
    }
}
