<#
.SYNOPSIS
    Removes an organization
.DESCRIPTION
    Deletes an organization from Terraform Cloud. This is a destructive operation that cannot be undone.
.PARAMETER Organization
    The organization name to delete
.EXAMPLE
    Remove-TfcOrganization -Organization "my-org"
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcOrganization {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    if ($PSCmdlet.ShouldProcess($Organization, "Delete organization (PERMANENT - cannot be undone)")) {
        Write-Verbose "Deleting organization: $Organization"
        Write-Warning "This will permanently delete the organization and all its workspaces, variables, and data!"
        try {
            Invoke-TfcApi -Uri "/organizations/$Organization" -Method DELETE
            return $true
        }
        catch {
            Write-Error "Failed to delete organization: $_"
            return $false
        }
    }
}
