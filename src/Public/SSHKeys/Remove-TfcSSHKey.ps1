<#
.SYNOPSIS
    Removes an SSH key
.DESCRIPTION
    Deletes an SSH key from an organization
.PARAMETER SSHKeyId
    The SSH key ID to delete
.EXAMPLE
    Remove-TfcSSHKey -SSHKeyId "sshkey-abc123"
.OUTPUTS
    None
#>
function Remove-TfcSSHKey {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SSHKeyId
    )

    if ($PSCmdlet.ShouldProcess("SSH Key $SSHKeyId", "Delete")) {
        Write-Verbose "Deleting SSH key: $SSHKeyId"
        Invoke-TfcApi -Uri "/ssh-keys/$SSHKeyId" -Method DELETE | Out-Null
        return $true
    }
}
