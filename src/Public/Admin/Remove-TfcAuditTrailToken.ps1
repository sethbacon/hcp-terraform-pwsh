<#
.SYNOPSIS
    Removes an audit trail token
.DESCRIPTION
    Deletes an audit trail token (admin only)
.PARAMETER TokenId
    The ID of the audit trail token to remove
.EXAMPLE
    Remove-TfcAuditTrailToken -TokenId "at-123"
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcAuditTrailToken {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TokenId
    )

    if ($PSCmdlet.ShouldProcess("Audit trail token $TokenId", "Delete token")) {
        Write-Verbose "Removing audit trail token: $TokenId"

        try {
            Invoke-TfcApi -Uri "/audit-trail-tokens/$TokenId" -Method DELETE
            Write-Verbose "Successfully deleted audit trail token: $TokenId"
            return $true
        } catch {
            Write-Error "Failed to delete audit trail token: $_"
            return $false
        }
    }

    return $false
}
