<#
.SYNOPSIS
    Gets run permissions for the current user
.DESCRIPTION
    Retrieves the permissions the current user has on a specific run
.PARAMETER RunId
    The ID of the run
.EXAMPLE
    Get-TfcRunPermission -RunId "run-123"
.OUTPUTS
    PSCustomObject with permission details (can-apply, can-cancel, can-discard, etc.)
#>
function Get-TfcRunPermission {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    Write-Verbose "Retrieving permissions for run: $RunId"

    $run = Invoke-TfcApi -Uri "/runs/$RunId"

    if ($run.data.attributes.permissions) {
        return $run.data.attributes.permissions
    } else {
        Write-Warning "No permissions information available for run $RunId"
        return $null
    }
}
