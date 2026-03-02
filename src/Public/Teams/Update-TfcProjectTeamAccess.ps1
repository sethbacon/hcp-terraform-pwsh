function Update-TfcProjectTeamAccess {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamProjectId,
        [Parameter(Mandatory = $false)]
        [ValidateSet('read', 'maintain', 'admin', 'write')]
        [string]$Access,
        [Parameter(Mandatory = $false)]
        [ValidateSet('read', 'write', 'apply', 'none')]
        [string]$RunsAccess,
        [Parameter(Mandatory = $false)]
        [ValidateSet('read', 'write', 'none')]
        [string]$VariablesAccess,
        [Parameter(Mandatory = $false)]
        [ValidateSet('read', 'write', 'none')]
        [string]$StateVersionsAccess,
        [Parameter(Mandatory = $false)]
        [ValidateSet('read', 'write', 'none')]
        [string]$SentinelMocksAccess,
        [Parameter(Mandatory = $false)]
        [ValidateSet('read', 'write', 'none')]
        [string]$WorkspaceLockingAccess
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "team-projects"
            attributes = @{}
        }
    }

    if ($Access) { $body.data.attributes.access = $Access }
    if ($RunsAccess) { $body.data.attributes.'runs-access' = $RunsAccess }
    if ($VariablesAccess) { $body.data.attributes.'variables-access' = $VariablesAccess }
    if ($StateVersionsAccess) { $body.data.attributes.'state-versions-access' = $StateVersionsAccess }
    if ($SentinelMocksAccess) { $body.data.attributes.'sentinel-mocks-access' = $SentinelMocksAccess }
    if ($WorkspaceLockingAccess) { $body.data.attributes.'workspace-locking-access' = $WorkspaceLockingAccess }

    $requestBody = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Team Project Access '$TeamProjectId'", "Update access")) {
        Write-Verbose "Updating team project access: $TeamProjectId"
        return Invoke-TfcApi -Uri "/team-projects/$TeamProjectId" -Method PATCH -Body $requestBody
    }
}
