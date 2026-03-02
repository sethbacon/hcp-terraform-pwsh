<#
.SYNOPSIS
    Gets tag bindings for a project
.DESCRIPTION
    Retrieves the tag bindings associated with a specific project
.PARAMETER ProjectId
    The project ID
.EXAMPLE
    Get-TfcProjectTagBinding -ProjectId "prj-abc123"
.OUTPUTS
    PSCustomObject representing the project's tag bindings
#>
function Get-TfcProjectTagBinding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId
    )

    Initialize-TfcConnection

    Write-Verbose "Getting tag bindings for project: $ProjectId"
    return Invoke-TfcApi -Uri "/projects/$ProjectId/tag-bindings" -Method GET
}
