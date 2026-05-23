<#
.SYNOPSIS
    Lists notification configurations for a project
.DESCRIPTION
    Retrieves the notification configurations attached to a project
.PARAMETER ProjectId
    The project ID
.EXAMPLE
    Get-TfcProjectNotificationConfiguration -ProjectId "prj-abc123"
.OUTPUTS
    PSCustomObject representing the project notification configurations
#>
function Get-TfcProjectNotificationConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId
    )

    Write-Verbose "Listing notification configurations for project: $ProjectId"
    return Invoke-TfcApi -Uri "/projects/$ProjectId/notification-configurations"
}
