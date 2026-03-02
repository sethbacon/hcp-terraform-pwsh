<#
.SYNOPSIS
    Shows a specific run trigger
.DESCRIPTION
    Retrieves details of a specific run trigger by ID
.PARAMETER RunTriggerId
    The run trigger ID
.EXAMPLE
    Show-TfcRunTrigger -RunTriggerId "rt-abc123"
.OUTPUTS
    PSCustomObject representing the run trigger
#>
function Show-TfcRunTrigger {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunTriggerId
    )

    Write-Verbose "Getting run trigger: $RunTriggerId"
    return Invoke-TfcApi -Uri "/run-triggers/$RunTriggerId"
}
