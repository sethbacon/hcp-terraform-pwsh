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

Describe 'Get-TfcPolicyEvaluation' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
        It 'Should have RunId parameter as mandatory' {
            $command = Get-Command Get-TfcPolicyEvaluation
            $command.Parameters['RunId'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have PolicyEvaluationId parameter as optional' {
            $command = Get-Command Get-TfcPolicyEvaluation
            $command.Parameters['PolicyEvaluationId'].Attributes.Mandatory | Should -Be $false
        }
    }

    Context 'Getting policy evaluations for a run' {
        It 'Should call correct API endpoint when listing evaluations' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = @(Get-MockPolicyEvaluation) }
            }

            Get-TfcPolicyEvaluation -RunId 'run-123'

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/runs/run-123/policy-evaluations'
            }
        }

        It 'Should return policy evaluation data' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = @(Get-MockPolicyEvaluation) }
            }

            $result = Get-TfcPolicyEvaluation -RunId 'run-123'

            $result.data | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Getting specific policy evaluation' {
        It 'Should call correct API endpoint when PolicyEvaluationId is specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockPolicyEvaluation }
            }

            Get-TfcPolicyEvaluation -RunId 'run-123' -PolicyEvaluationId 'poleval-456'

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                $Uri -eq '/policy-evaluations/poleval-456'
            }
        }
    }

    Context 'Verbose output' {
        It 'Should write verbose message when listing evaluations' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = @(Get-MockPolicyEvaluation) }
            }

            $verboseOutput = Get-TfcPolicyEvaluation -RunId 'run-123' -Verbose 4>&1 |
                Where-Object { $_ -is [System.Management.Automation.VerboseRecord] }

            $verboseOutput.Message | Should -Match 'Getting policy evaluations for run: run-123'
        }

        It 'Should write verbose message when getting specific evaluation' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = Get-MockPolicyEvaluation }
            }

            $verboseOutput = Get-TfcPolicyEvaluation -RunId 'run-123' -PolicyEvaluationId 'poleval-456' -Verbose 4>&1 |
                Where-Object { $_ -is [System.Management.Automation.VerboseRecord] }

            $verboseOutput.Message | Should -Match 'Getting policy evaluation: poleval-456'
        }
    }
}
