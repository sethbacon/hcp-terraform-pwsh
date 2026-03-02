<#
.SYNOPSIS
    Lists configuration versions for a workspace
.DESCRIPTION
    Retrieves all configuration versions for a specific workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcConfigurationVersionList -WorkspaceId "ws-abc123"
.OUTPUTS
    PSCustomObject representing configuration versions
#>
function Get-TfcConfigurationVersionList {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [switch]$AllPages,

        [Parameter()]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$PageNumber = 1
    )

    $uri = "/workspaces/$WorkspaceId/configuration-versions?page[size]=$PageSize&page[number]=$PageNumber"
    Write-Verbose "Getting configuration versions for workspace: $WorkspaceId"

    if ($AllPages) {
        return Get-AllPages -InitialUri $uri
    }
    return Invoke-TfcApi -Uri $uri
}
