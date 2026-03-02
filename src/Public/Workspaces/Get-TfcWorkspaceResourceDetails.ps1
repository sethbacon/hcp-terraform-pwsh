<#
.SYNOPSIS
    Get detailed workspace resource information
.DESCRIPTION
    Retrieves detailed information about a specific resource managed by a workspace
.PARAMETER ResourceId
    The ID of the resource (format: wsres-xxxxx)
.EXAMPLE
    Get-TfcWorkspaceResourceDetails -ResourceId wsres-abc123
#>
function Get-TfcWorkspaceResourceDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResourceId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for workspace resource: $ResourceId"
    return Invoke-TfcApi -Uri "/workspace-resources/$ResourceId" -Method GET
}
