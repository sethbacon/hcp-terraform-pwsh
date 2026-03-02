<#
.SYNOPSIS
    Updates organization entitlements
.DESCRIPTION
    Updates the entitlements/features enabled for an organization (admin only)
.PARAMETER Organization
    The name of the organization
.PARAMETER Entitlements
    Hashtable of entitlements to update (cost-estimation, sentinel, state-storage, etc.)
.EXAMPLE
    Update-TfcOrganizationEntitlement -Organization "my-org" -Entitlements @{ "cost-estimation" = $true; "sentinel" = $true }
.OUTPUTS
    PSCustomObject representing updated organization
#>
function Update-TfcOrganizationEntitlement {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [hashtable]$Entitlements
    )

    if ($PSCmdlet.ShouldProcess("Organization $Organization", "Update entitlements")) {
        $body = @{
            data = @{
                type = 'organizations'
                attributes = @{
                    entitlements = $Entitlements
                }
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Updating entitlements for organization: $Organization"

        return Invoke-TfcApi -Uri "/organizations/$Organization" -Method PATCH -Body $body
    }
}
