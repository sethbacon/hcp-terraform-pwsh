<#
.SYNOPSIS
    Get drift detection runs
.DESCRIPTION
    Retrieves drift detection runs for a workspace
.PARAMETER WorkspaceId
    The ID of the workspace
.PARAMETER PageSize
    Number of results per page (default: 20)
.PARAMETER PageNumber
    Page number to retrieve (default: 1)
.PARAMETER AllPages
    Retrieve all pages of results
.EXAMPLE
    Get-TfcDriftDetection -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing drift detection runs
#>
function Get-TfcDriftDetection {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    try {
        Initialize-TfcConnection

        $uri = "/workspaces/$WorkspaceId/drift-detection-runs?page%5Bnumber%5D=$PageNumber&page%5Bsize%5D=$PageSize"

        Write-Verbose "Getting drift detection runs for workspace: $WorkspaceId"

        if ($AllPages) {
            return Invoke-TfcApi -Uri $uri -Method GET -AllPages
        }

        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get drift detection runs: $($_.Exception.Message)"
    }
}
