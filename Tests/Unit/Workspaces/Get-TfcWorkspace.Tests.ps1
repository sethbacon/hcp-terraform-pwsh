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

Describe 'Get-TfcWorkspace' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            $command = Get-Command Get-TfcWorkspace
            $command.Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Name parameter as optional' {
            $command = Get-Command Get-TfcWorkspace
            $command.Parameters['Name'].Attributes.Mandatory | Should -Be $false
        }

        It 'Should have PageSize parameter with valid range 1-100' {
            $command = Get-Command Get-TfcWorkspace
            $pageSize = $command.Parameters['PageSize']
            $pageSize.Attributes.Where({$_.TypeId.Name -eq 'ValidateRangeAttribute'}).MinRange | Should -Be 1
            $pageSize.Attributes.Where({$_.TypeId.Name -eq 'ValidateRangeAttribute'}).MaxRange | Should -Be 100
        }

        It 'Should have AllPages switch parameter' {
            $command = Get-Command Get-TfcWorkspace
            $command.Parameters['AllPages'].SwitchParameter | Should -Be $true
        }
    }

    Context 'Getting specific workspace by name' {
        It 'Should call correct API endpoint when Name is specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockWorkspace -Name 'test-ws' -Organization 'test-org' }
            }

            Get-TfcWorkspace -Organization 'test-org' -Name 'test-ws'

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/organizations/test-org/workspaces/test-ws'
            }
        }

        It 'Should return workspace data for specific workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockWorkspace -Name 'my-workspace' -Organization 'my-org' }
            }

            $result = Get-TfcWorkspace -Organization 'my-org' -Name 'my-workspace'

            $result.data.type | Should -Be 'workspaces'
            $result.data.attributes.name | Should -Be 'my-workspace'
        }
    }

    Context 'Listing all workspaces' {
        It 'Should call correct API endpoint when listing workspaces' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return Get-MockWorkspaceList -Count 3 -Organization 'test-org'
            }

            Get-TfcWorkspace -Organization 'test-org'

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -like '/organizations/test-org/workspaces?page*'
            }
        }

        It 'Should use default page size of 20' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return Get-MockWorkspaceList -Count 3
            }

            Get-TfcWorkspace -Organization 'test-org'

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -match 'page%5Bsize%5D=20'
            }
        }

        It 'Should use custom page size when specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return Get-MockWorkspaceList -Count 5
            }

            Get-TfcWorkspace -Organization 'test-org' -PageSize 50

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -match 'page%5Bsize%5D=50'
            }
        }

        It 'Should use custom page number when specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return Get-MockWorkspaceList -Count 3
            }

            Get-TfcWorkspace -Organization 'test-org' -PageNumber 3

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -match 'page%5Bnumber%5D=3'
            }
        }

        It 'Should pass AllPages switch to Invoke-TfcApi' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return Get-MockWorkspaceList -Count 100
            }

            Get-TfcWorkspace -Organization 'test-org' -AllPages

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $AllPages -eq $true
            }
        }

        It 'Should return multiple workspaces' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return Get-MockWorkspaceList -Count 5 -Organization 'test-org'
            }

            $result = Get-TfcWorkspace -Organization 'test-org'

            $result.data.Count | Should -Be 5
            $result.data[0].type | Should -Be 'workspaces'
        }
    }

    Context 'Verbose output' {
        It 'Should write verbose message when getting specific workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockWorkspace }
            }

            $verboseOutput = Get-TfcWorkspace -Organization 'test-org' -Name 'test-ws' -Verbose 4>&1 | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] }

            $verboseOutput.Message | Should -Match 'Getting workspace: test-org/test-ws'
        }

        It 'Should write verbose message when listing workspaces' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return Get-MockWorkspaceList
            }

            $verboseOutput = Get-TfcWorkspace -Organization 'test-org' -Verbose 4>&1 | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] }

            $verboseOutput.Message | Should -Match 'Getting workspaces for organization: test-org'
        }
    }
}
