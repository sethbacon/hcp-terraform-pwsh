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

Describe 'Lock-TfcWorkspace' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have Organization parameter as mandatory' {
            $command = Get-Command Lock-TfcWorkspace
            $command.Parameters['Organization'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Name parameter as mandatory' {
            $command = Get-Command Lock-TfcWorkspace
            $command.Parameters['Name'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have Reason parameter as optional' {
            $command = Get-Command Lock-TfcWorkspace
            $command.Parameters['Reason'].Attributes.Mandatory | Should -Be $false
        }
    }

    Context 'Locking workspace' {
        It 'Should call correct API endpoint with POST method' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockWorkspace -Locked $true }
            }

            Lock-TfcWorkspace -Organization 'test-org' -Name 'test-workspace'

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/organizations/test-org/workspaces/test-workspace/actions/lock' -and
                $Method -eq 'Post'
            }
        }

        It 'Should include custom reason in request body when provided' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.reason | Should -Be 'Emergency maintenance'
                return @{ data = Get-MockWorkspace -Locked $true }
            }

            Lock-TfcWorkspace -Organization 'test-org' -Name 'test-workspace' -Reason 'Emergency maintenance'
        }

        It 'Should include default reason when not provided' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param($Uri, $Method, $Body)
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.reason | Should -Be 'Locked via API'
                return @{ data = Get-MockWorkspace -Locked $true }
            }

            Lock-TfcWorkspace -Organization 'test-org' -Name 'test-workspace'
        }

        It 'Should return locked workspace data' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockWorkspace -Locked $true }
            }

            $result = Lock-TfcWorkspace -Organization 'test-org' -Name 'test-workspace'

            $result.data.attributes.locked | Should -Be $true
        }
    }

    Context 'Verbose output' {
        It 'Should write verbose message when locking workspace' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockWorkspace -Locked $true }
            }

            $verboseOutput = Lock-TfcWorkspace -Organization 'test-org' -Name 'test-workspace' -Verbose 4>&1 | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] }

            $verboseOutput.Message | Should -Match "Locking workspace 'test-workspace' in organization 'test-org'"
        }
    }
}
