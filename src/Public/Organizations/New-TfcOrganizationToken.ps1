<#
.SYNOPSIS
    Creates an organization token
.DESCRIPTION
    Generates an API token for an organization
.PARAMETER Organization
    The organization name
.PARAMETER ExpiredAt
    Optional expiration date (RFC3339 format)
.EXAMPLE
    New-TfcOrganizationToken -Organization "my-org"
.OUTPUTS
    PSCustomObject representing the created token (includes token value)
#>
function New-TfcOrganizationToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

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

    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create organization token")) {
        Write-Verbose "Creating organization token for: $Organization"
        $result = Invoke-TfcApi -Uri "/organizations/$Organization/authentication-token" -Method POST -Body $body

        Write-Warning "Save the token value from the response - it will not be shown again!"
        return $result
    }
}
