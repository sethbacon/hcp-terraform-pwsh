<#
.SYNOPSIS
    Update SAML settings for an organization
.DESCRIPTION
    Updates SAML SSO configuration for an organization (requires admin access)
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER SSOEndpoint
    The SSO endpoint URL
.PARAMETER SLOEndpoint
    The single logout endpoint URL
.PARAMETER Certificate
    The X.509 certificate for SAML
.PARAMETER Enabled
    Whether SAML is enabled
.EXAMPLE
    Update-TfcSAMLSettings -OrganizationName my-org -Enabled $true -SSOEndpoint "https://idp.example.com/sso"
#>
function Update-TfcSAMLSettings {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $false)]
        [string]$SSOEndpoint,
        [Parameter(Mandatory = $false)]
        [string]$SLOEndpoint,
        [Parameter(Mandatory = $false)]
        [string]$Certificate,
        [Parameter(Mandatory = $false)]
        [bool]$Enabled
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "saml-settings"
            attributes = @{}
        }
    }

    if ($SSOEndpoint) {
        $body.data.attributes.'sso-endpoint-url' = $SSOEndpoint
    }

    if ($SLOEndpoint) {
        $body.data.attributes.'slo-endpoint-url' = $SLOEndpoint
    }

    if ($Certificate) {
        $body.data.attributes.'idp-cert' = $Certificate
    }

    if ($PSBoundParameters.ContainsKey('Enabled')) {
        $body.data.attributes.enabled = $Enabled
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Organization: $OrganizationName", "Update SAML settings")) {
        Write-Verbose "Updating SAML settings for organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/saml-settings" -Method PATCH -Body $bodyJson
    }
}
