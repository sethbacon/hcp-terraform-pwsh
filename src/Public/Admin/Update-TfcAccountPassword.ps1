<#
.SYNOPSIS
    Updates the current user's password
.DESCRIPTION
    Changes the password for the currently authenticated user
.PARAMETER CurrentPassword
    The current password
.PARAMETER NewPassword
    The new password
.PARAMETER NewPasswordConfirmation
    Confirmation of the new password
.EXAMPLE
    Update-TfcAccountPassword -CurrentPassword (ConvertTo-SecureString "old" -AsPlainText -Force) -NewPassword (ConvertTo-SecureString "new" -AsPlainText -Force) -NewPasswordConfirmation (ConvertTo-SecureString "new" -AsPlainText -Force)
.OUTPUTS
    PSCustomObject representing the updated account
#>
function Update-TfcAccountPassword {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]$CurrentPassword,

        [Parameter(Mandatory = $true)]
        [securestring]$NewPassword,

        [Parameter(Mandatory = $true)]
        [securestring]$NewPasswordConfirmation
    )

    $currentPwd = [System.Net.NetworkCredential]::new('', $CurrentPassword).Password
    $newPwd = [System.Net.NetworkCredential]::new('', $NewPassword).Password
    $confirmPwd = [System.Net.NetworkCredential]::new('', $NewPasswordConfirmation).Password

    $body = @{
        data = @{
            type       = "users"
            attributes = @{
                'current-password'      = $currentPwd
                'password'              = $newPwd
                'password-confirmation' = $confirmPwd
            }
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Updating account password"
    if ($PSCmdlet.ShouldProcess("Current user account", "Update password")) {
        return Invoke-TfcApi -Uri "/account/password" -Method PATCH -Body $body
    }
}
