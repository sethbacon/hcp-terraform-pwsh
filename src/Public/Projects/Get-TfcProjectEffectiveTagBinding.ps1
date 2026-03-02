<#
.SYNOPSIS
    Gets effective tag bindings for a project
.DESCRIPTION
    Retrieves the effective tag bindings for a project, including inherited tag bindings
.PARAMETER ProjectId
    The project ID
.EXAMPLE
    Get-TfcProjectEffectiveTagBinding -ProjectId "prj-abc123"
.OUTPUTS
    PSCustomObject representing the project's effective tag bindings
#>
function Get-TfcProjectEffectiveTagBinding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId
    )

    Initialize-TfcConnection

    Write-Verbose "Getting effective tag bindings for project: $ProjectId"
    return Invoke-TfcApi -Uri "/projects/$ProjectId/effective-tag-bindings" -Method GET
}
