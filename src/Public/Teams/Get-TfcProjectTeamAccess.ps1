function Get-TfcProjectTeamAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId
    )

    Initialize-TfcConnection

    Write-Verbose "Listing team access for project: $ProjectId"
    return Invoke-TfcApi -Uri "/projects/$ProjectId/relationships/team-projects" -Method GET
}
