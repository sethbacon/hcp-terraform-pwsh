function Get-TfcProjectTeamAccessDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamProjectId
    )

    Initialize-TfcConnection

    Write-Verbose "Getting team project access details: $TeamProjectId"
    return Invoke-TfcApi -Uri "/team-projects/$TeamProjectId" -Method GET
}
