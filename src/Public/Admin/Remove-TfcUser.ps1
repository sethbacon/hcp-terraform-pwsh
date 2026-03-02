<#
.SYNOPSIS
    Removes a user from the organization
.DESCRIPTION
    Deletes a user account from HCP Terraform (admin only)
.PARAMETER UserId
    The ID of the user to remove
.EXAMPLE
    Remove-TfcUser -UserId "user-123"
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcUser {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserId
    )

    if ($PSCmdlet.ShouldProcess("User $UserId", "Delete user account")) {
        Write-Verbose "Removing user: $UserId"
        Write-Warning "This will permanently delete the user account"

        try {
            Invoke-TfcApi -Uri "/admin/users/$UserId" -Method DELETE
            Write-Verbose "Successfully deleted user: $UserId"
            return $true
        } catch {
            Write-Error "Failed to delete user: $_"
            return $false
        }
    }

    return $false
}
