function Remove-TfcProjectTeamAccess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamProjectId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Team Project Access '$TeamProjectId'", "Remove access")) {
        Write-Verbose "Removing team project access: $TeamProjectId"
        Invoke-TfcApi -Uri "/team-projects/$TeamProjectId" -Method DELETE | Out-Null
        return $true
    }
}
