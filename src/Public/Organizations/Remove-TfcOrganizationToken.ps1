<#
.SYNOPSIS
    Removes an organization token
.DESCRIPTION
    Deletes the API token for an organization
.PARAMETER Organization
    The organization name
.EXAMPLE
    Remove-TfcOrganizationToken -Organization "my-org"
.OUTPUTS
    None
#>
function Remove-TfcOrganizationToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    if ($PSCmdlet.ShouldProcess("Organization $Organization Token", "Delete")) {
        Write-Verbose "Deleting organization token for: $Organization"
        Invoke-TfcApi -Uri "/organizations/$Organization/authentication-token" -Method DELETE | Out-Null
        return $true
    }
}
