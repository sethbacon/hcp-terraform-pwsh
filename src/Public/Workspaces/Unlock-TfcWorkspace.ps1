<#
.SYNOPSIS
    Unlocks a workspace
.DESCRIPTION
    Unlocks a workspace to allow runs
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The workspace name
.EXAMPLE
    Unlock-TfcWorkspace -Organization "my-org" -Name "my-workspace"
.OUTPUTS
    PSCustomObject representing the unlocked workspace
#>
function Unlock-TfcWorkspace {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Write-Verbose "Unlocking workspace '$Name' in organization '$Organization'"
    return Invoke-TfcApi -Uri "/organizations/$Organization/workspaces/$Name/actions/unlock" -Method POST
}
