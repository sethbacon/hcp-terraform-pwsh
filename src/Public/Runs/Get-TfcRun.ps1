<#
.SYNOPSIS
    Gets runs for a workspace
.DESCRIPTION
    Retrieves runs from a Terraform Cloud workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcRun -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing workspace runs
#>
function Get-TfcRun {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $uri = "/workspaces/$WorkspaceId/runs?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
    Write-Verbose "Getting runs for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
}
