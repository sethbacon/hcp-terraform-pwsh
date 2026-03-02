<#
.SYNOPSIS
    Creates an audit trail token
.DESCRIPTION
    Generates a new audit trail token for streaming audit logs (admin only)
.PARAMETER Organization
    The name of the organization
.PARAMETER ExpiresAt
    Optional expiration date for the token
.EXAMPLE
    New-TfcAuditTrailToken -Organization "my-org"
.EXAMPLE
    New-TfcAuditTrailToken -Organization "my-org" -ExpiresAt (Get-Date).AddDays(90)
.OUTPUTS
    PSCustomObject representing the created token (includes token value - save it!)
#>
function New-TfcAuditTrailToken {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [datetime]$ExpiresAt
    )

    if ($PSCmdlet.ShouldProcess("Organization $Organization", "Create audit trail token")) {
        $body = @{
            data = @{
                type = 'audit-trail-tokens'
                attributes = @{}
            }
        }

        if ($ExpiresAt) {
            $body.data.attributes.'expired-at' = $ExpiresAt.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10

        Write-Verbose "Creating audit trail token for organization: $Organization"
        Write-Warning "Save the token value - it will only be shown once!"

        return Invoke-TfcApi -Uri "/organizations/$Organization/audit-trail-tokens" -Method POST -Body $bodyJson
    }
}
