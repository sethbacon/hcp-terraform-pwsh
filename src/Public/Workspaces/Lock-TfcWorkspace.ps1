<#
.SYNOPSIS
    Locks a workspace
.DESCRIPTION
    Locks a workspace to prevent runs
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The workspace name
.PARAMETER Reason
    Optional reason for locking the workspace
.EXAMPLE
    Lock-TfcWorkspace -Organization "my-org" -Name "my-workspace" -Reason "Maintenance"
.OUTPUTS
    PSCustomObject representing the locked workspace
#>
function Lock-TfcWorkspace {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Reason = "Locked via API"
    )

    $body = @{
        reason = $Reason
    } | ConvertTo-Json

    Write-Verbose "Locking workspace '$Name' in organization '$Organization'"
    return Invoke-TfcApi -Uri "/organizations/$Organization/workspaces/$Name/actions/lock" -Method POST -Body $body
}
