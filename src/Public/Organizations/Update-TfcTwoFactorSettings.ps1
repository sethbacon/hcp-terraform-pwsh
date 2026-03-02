<#
.SYNOPSIS
    Update two-factor authentication settings
.DESCRIPTION
    Updates 2FA requirements for an organization
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER Required
    Whether 2FA is required for all members
.EXAMPLE
    Update-TfcTwoFactorSettings -OrganizationName my-org -Required $true
#>
function Update-TfcTwoFactorSettings {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $true)]
        [bool]$Required
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "two-factor-settings"
            attributes = @{
                required = $Required
            }
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Organization: $OrganizationName", "Update 2FA settings")) {
        Write-Verbose "Updating two-factor settings for organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/two-factor" -Method PATCH -Body $body
    }
}
