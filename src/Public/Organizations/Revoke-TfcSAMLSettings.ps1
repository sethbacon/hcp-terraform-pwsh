<#
.SYNOPSIS
    Revoke SAML settings for an organization
.DESCRIPTION
    Disables and removes SAML SSO configuration for an organization (requires admin access)
.PARAMETER OrganizationName
    The name of the organization
.EXAMPLE
    Revoke-TfcSAMLSettings -OrganizationName my-org
#>
function Revoke-TfcSAMLSettings {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Organization: $OrganizationName", "Revoke SAML settings")) {
        Write-Verbose "Revoking SAML settings for organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/saml-settings/actions/revoke" -Method POST
    }
}
