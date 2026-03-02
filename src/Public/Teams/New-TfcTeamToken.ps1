<#
.SYNOPSIS
    Creates a team token
.DESCRIPTION
    Generates an API token for a team
.PARAMETER TeamId
    The team ID
.PARAMETER ExpiredAt
    Optional expiration date (RFC3339 format)
.EXAMPLE
    New-TfcTeamToken -TeamId "team-abc123"
.OUTPUTS
    PSCustomObject representing the created token (includes token value)
#>
function New-TfcTeamToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId,

        [Parameter(Mandatory = $false)]
        [string]$ExpiredAt
    )

    $attributes = @{}
    if ($ExpiredAt) {
        $attributes['expired-at'] = $ExpiredAt
    }

    $body = @{
        data = @{
            type = "authentication-tokens"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Team: $TeamId", "Create team token")) {
        Write-Verbose "Creating team token for team: $TeamId"
        $result = Invoke-TfcApi -Uri "/teams/$TeamId/authentication-token" -Method POST -Body $body

        Write-Warning "Save the token value from the response - it will not be shown again!"
        return $result
    }
}
