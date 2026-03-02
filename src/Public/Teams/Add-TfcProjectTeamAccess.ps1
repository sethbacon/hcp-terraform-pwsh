function Add-TfcProjectTeamAccess {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,
        [Parameter(Mandatory = $true)]
        [string]$TeamId,
        [Parameter(Mandatory = $true)]
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
            attributes = @{
                access = $Access
            }
            relationships = @{
                team = @{
                    data = @{
                        type = "teams"
                        id = $TeamId
                    }
                }
                project = @{
                    data = @{
                        type = "projects"
                        id = $ProjectId
                    }
                }
            }
        }
    }

    if ($RunsAccess) { $body.data.attributes.'runs-access' = $RunsAccess }
    if ($VariablesAccess) { $body.data.attributes.'variables-access' = $VariablesAccess }
    if ($StateVersionsAccess) { $body.data.attributes.'state-versions-access' = $StateVersionsAccess }
    if ($SentinelMocksAccess) { $body.data.attributes.'sentinel-mocks-access' = $SentinelMocksAccess }
    if ($WorkspaceLockingAccess) { $body.data.attributes.'workspace-locking-access' = $WorkspaceLockingAccess }

    $requestBody = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Project '$ProjectId'", "Add team access for team '$TeamId'")) {
        Write-Verbose "Adding team '$TeamId' access to project: $ProjectId"
        return Invoke-TfcApi -Uri "/team-projects" -Method POST -Body $requestBody
    }
}
