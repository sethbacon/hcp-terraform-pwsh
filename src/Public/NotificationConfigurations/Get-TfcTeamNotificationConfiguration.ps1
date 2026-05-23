<#
.SYNOPSIS
    Lists notification configurations for a team
.DESCRIPTION
    Retrieves the notification configurations attached to a team
.PARAMETER TeamId
    The team ID
.EXAMPLE
    Get-TfcTeamNotificationConfiguration -TeamId "team-abc123"
.OUTPUTS
    PSCustomObject representing the team notification configurations
#>
function Get-TfcTeamNotificationConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId
    )

    Write-Verbose "Listing notification configurations for team: $TeamId"
    return Invoke-TfcApi -Uri "/teams/$TeamId/notification-configurations"
}
