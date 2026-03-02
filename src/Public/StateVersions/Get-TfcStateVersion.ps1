<#
.SYNOPSIS
    Gets state versions for a workspace
.DESCRIPTION
    Retrieves state versions from a Terraform Cloud workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER StateVersionId
    Optional state version ID to get a specific version
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcStateVersion -WorkspaceId "ws-123"
.EXAMPLE
    Get-TfcStateVersion -StateVersionId "sv-abc123"
.OUTPUTS
    PSCustomObject representing state versions
#>
function Get-TfcStateVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [string]$StateVersionId,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    if ($StateVersionId) {
        Write-Verbose "Getting state version: $StateVersionId"
        return Invoke-TfcApi -Uri "/state-versions/$StateVersionId"
    }
    elseif ($WorkspaceId) {
        if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
            throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
        }

        $uri = "/workspaces/$WorkspaceId/state-versions?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
        Write-Verbose "Getting state versions for workspace: $WorkspaceId"
        return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
    }
    else {
        throw "Either WorkspaceId or StateVersionId must be provided"
    }
}
