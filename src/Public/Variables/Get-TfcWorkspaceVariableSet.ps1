<#
.SYNOPSIS
    Gets variable sets for a workspace
.DESCRIPTION
    Retrieves variable sets assigned to a specific workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcWorkspaceVariableSet -WorkspaceId "ws-abc123"
.EXAMPLE
    Get-TfcWorkspaceVariableSet -WorkspaceId "ws-abc123" -AllPages
.OUTPUTS
    PSCustomObject representing the workspace's variable sets
#>
function Get-TfcWorkspaceVariableSet {
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

    $uri = "/workspaces/$WorkspaceId/varsets?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
    Write-Verbose "Getting variable sets for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
}
