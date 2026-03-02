<#
.SYNOPSIS
    Creates a user token
.DESCRIPTION
    Generates a new API token for the current user
.PARAMETER Description
    Description for the token
.PARAMETER ExpiredAt
    Optional expiration date (RFC3339 format)
.EXAMPLE
    New-TfcUserToken -Description "CI/CD Pipeline Token"
.OUTPUTS
    PSCustomObject representing the created token (includes token value)
#>
function New-TfcUserToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string]$ExpiredAt
    )

    $attributes = @{
        description = $Description
    }

    if ($ExpiredAt) {
        $attributes['expired-at'] = $ExpiredAt
    }

    $body = @{
        data = @{
            type = "authentication-tokens"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Current user", "Create user token: $Description")) {
        Write-Verbose "Creating user token: $Description"
        $result = Invoke-TfcApi -Uri "/authentication-tokens" -Method POST -Body $body

        Write-Warning "Save the token value from the response - it will not be shown again!"
        return $result
    }
}
