<#
.SYNOPSIS
    Lists query runs for a workspace
.DESCRIPTION
    Retrieves the query runs that have been created against a workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER PageNumber
    The page number (default: 1)
.PARAMETER PageSize
    Number of items per page (default: 20)
.PARAMETER AllPages
    Return all pages of results
.EXAMPLE
    Get-TfcQuery -WorkspaceId "ws-abc123"
.OUTPUTS
    PSCustomObject representing the workspace's query runs
#>
function Get-TfcQuery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $uri = "/workspaces/$WorkspaceId/queries?page%5Bnumber%5D=$PageNumber&page%5Bsize%5D=$PageSize"

    Write-Verbose "Listing queries for workspace: $WorkspaceId"
    if ($AllPages) {
        return Get-AllPages -InitialUri $uri
    }
    return Invoke-TfcApi -Uri $uri
}
