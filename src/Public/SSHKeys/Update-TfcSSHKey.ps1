<#
.SYNOPSIS
    Updates an SSH key
.DESCRIPTION
    Updates the name of an existing SSH key
.PARAMETER SSHKeyId
    The SSH key ID
.PARAMETER Name
    New name for the key
.EXAMPLE
    Update-TfcSSHKey -SSHKeyId "sshkey-abc123" -Name "Updated Key Name"
.OUTPUTS
    PSCustomObject representing the updated SSH key
#>
function Update-TfcSSHKey {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SSHKeyId,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $body = @{
        data = @{
            type = "ssh-keys"
            attributes = @{
                name = $Name
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating SSH key: $SSHKeyId"
    if ($PSCmdlet.ShouldProcess("SSH Key: $SSHKeyId", "Update SSH key")) {
        return Invoke-TfcApi -Uri "/ssh-keys/$SSHKeyId" -Method PATCH -Body $body
    }
}
