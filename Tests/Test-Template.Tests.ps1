# Pester Test Template for TerraformCloud Functions
# Copy this template for each function and customize

BeforeAll {
    # Import test helpers
    $helpersPath = Join-Path $PSScriptRoot '..' '..' 'Helpers' 'TestHelpers.psm1'
    Import-Module $helpersPath -Force

    # Import mocks
    $mocksPath = Join-Path $PSScriptRoot '..' '..' 'Mocks' 'TfcMocks.psm1'
    Import-Module $mocksPath -Force

    # Import module
    $modulePath = Join-Path $PSScriptRoot '..' '..' '..' 'Output' 'TerraformCloud' 'TerraformCloud.psd1'
    Import-Module $modulePath -Force

    # Set test token
    $env:TFE_TOKEN = "test-token-12345"
}

AfterAll {
    Remove-Module TerraformCloud -Force -ErrorAction SilentlyContinue
    Remove-Module TestHelpers -Force -ErrorAction SilentlyContinue
    Remove-Module TfcMocks -Force -ErrorAction SilentlyContinue
}Describe 'FunctionName' {
    BeforeEach {
        # Mock Invoke-TfcApi using mock data
        # Example: For workspace function
        Mock Invoke-TfcApi {
            return @{
                data = Get-MockWorkspace -Name 'test-workspace'
            }
        }

        # Example: For run function
        # Mock Invoke-TfcApi {
        #     return @{
        #         data = Get-MockRun -Status 'pending'
        #     }
        # }
    }

    Context 'Parameter Validation' {
        It 'Should have required parameters' {
            (Get-Command FunctionName).Parameters['ParamName'].Attributes.Mandatory | Should -BeTrue
        }

        It 'Should validate parameter types' {
            (Get-Command FunctionName).Parameters['ParamName'].ParameterType.Name | Should -Be 'String'
        }
    }

    Context 'Functionality' {
        It 'Should call Invoke-TfcApi with correct URI' {
            FunctionName -ParamName 'test-value'

            Should -Invoke Invoke-TfcApi -Times 1 -ParameterFilter {
                $Uri -eq '/expected/uri'
            }
        }

        It 'Should return expected data' {
            $result = FunctionName -ParamName 'test-value'

            $result | Should -Not -BeNullOrEmpty
            $result.id | Should -Be 'test-id'
        }

        It 'Should handle errors gracefully' {
            Mock Invoke-TfcApi { throw "API Error" }

            { FunctionName -ParamName 'test-value' } | Should -Throw
        }
    }

    Context 'ShouldProcess Support' {
        It 'Should support -WhatIf' {
            # Only for functions with SupportsShouldProcess
            FunctionName -ParamName 'test-value' -WhatIf

            Should -Invoke Invoke-TfcApi -Times 0
        }

        It 'Should support -Confirm' {
            # Only for functions with SupportsShouldProcess
            # Mock user confirmation
            Mock Get-ConfirmationResponse { return $false }

            FunctionName -ParamName 'test-value' -Confirm:$false

            Should -Invoke Invoke-TfcApi -Times 1
        }
    }
}
