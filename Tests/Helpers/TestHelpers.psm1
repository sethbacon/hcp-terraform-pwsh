# Test Helper Functions for TerraformCloud Module
# Used by unit and integration tests

<#
.SYNOPSIS
    Creates a mock TFC API response
.PARAMETER Data
    The data to return in the response
.PARAMETER Meta
    Optional metadata
#>
function New-MockTfcResponse {
    param(
        [Parameter(Mandatory = $true)]
        $Data,

        [Parameter(Mandatory = $false)]
        $Meta,

        [Parameter(Mandatory = $false)]
        $Included
    )

    $response = @{
        data = $Data
    }

    if ($Meta) {
        $response.meta = $Meta
    }

    if ($Included) {
        $response.included = $Included
    }

    return $response
}

<#
.SYNOPSIS
    Creates mock workspace data
#>
function New-MockWorkspace {
    param(
        [string]$Id = "ws-$(New-Guid)",
        [string]$Name = "test-workspace",
        [string]$Organization = "test-org"
    )

    return @{
        id = $Id
        type = 'workspaces'
        attributes = @{
            name = $Name
            'auto-apply' = $false
            'terraform-version' = '1.5.0'
            'resource-count' = 0
            locked = $false
        }
        relationships = @{
            organization = @{
                data = @{
                    id = $Organization
                    type = 'organizations'
                }
            }
        }
    }
}

<#
.SYNOPSIS
    Creates mock run data
#>
function New-MockRun {
    param(
        [string]$Id = "run-$(New-Guid)",
        [string]$Status = "pending",
        [string]$WorkspaceId = "ws-123"
    )

    return @{
        id = $Id
        type = 'runs'
        attributes = @{
            status = $Status
            'status-timestamps' = @{}
            message = "Test run"
            permissions = @{
                'can-apply' = $true
                'can-cancel' = $true
                'can-discard' = $true
            }
        }
        relationships = @{
            workspace = @{
                data = @{
                    id = $WorkspaceId
                    type = 'workspaces'
                }
            }
        }
    }
}

<#
.SYNOPSIS
    Sets up a mock for Invoke-TfcApi to return test data
#>
function Set-TfcApiMock {
    param(
        [Parameter(Mandatory = $true)]
        $ReturnValue,

        [string]$ParameterFilter = '*'
    )

    Mock -CommandName Invoke-TfcApi -MockWith {
        return $ReturnValue
    } -ParameterFilter { $Uri -like $ParameterFilter }
}

<#
.SYNOPSIS
    Sets up common test environment
#>
function Initialize-TestEnvironment {
    # Set TFE_TOKEN if not set
    if (-not $env:TFE_TOKEN) {
        $env:TFE_TOKEN = "test-token-$(New-Guid)"
    }

    # Import module
    $modulePath = Join-Path $PSScriptRoot '..' 'Output' 'TerraformCloud' 'TerraformCloud.psd1'
    Import-Module $modulePath -Force
}

<#
.SYNOPSIS
    Removes test environment modules
#>
function Remove-TestEnvironment {
    Remove-Module TerraformCloud -Force -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function @(
    'New-MockTfcResponse',
    'New-MockWorkspace',
    'New-MockRun',
    'Set-TfcApiMock',
    'Initialize-TestEnvironment',
    'Remove-TestEnvironment'
)
