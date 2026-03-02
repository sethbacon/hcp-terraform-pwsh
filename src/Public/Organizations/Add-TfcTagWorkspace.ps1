<#
.SYNOPSIS
    Adds workspaces to a tag
.DESCRIPTION
    Associates one or more workspaces with a specific tag
.PARAMETER TagId
    The tag ID
.PARAMETER WorkspaceIds
    Array of workspace IDs to add to the tag
.EXAMPLE
    Add-TfcTagWorkspace -TagId "tag-abc123" -WorkspaceIds @("ws-abc123", "ws-def456")
.OUTPUTS
    None
#>
function Add-TfcTagWorkspace {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TagId,

        [Parameter(Mandatory = $true)]
        [string[]]$WorkspaceIds
    )

    $body = @{
        data = @($WorkspaceIds | ForEach-Object {
            @{ type = "workspaces"; id = $_ }
        })
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Adding workspaces to tag: $TagId"
    return Invoke-TfcApi -Uri "/tags/$TagId/relationships/workspaces" -Method POST -Body $body
}
