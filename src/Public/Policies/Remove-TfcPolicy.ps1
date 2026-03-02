<#
.SYNOPSIS
    Removes a policy
.DESCRIPTION
    Deletes a Sentinel or OPA policy from the organization
.PARAMETER PolicyId
    The policy ID to remove
.EXAMPLE
    Remove-TfcPolicy -PolicyId "pol-123"
.OUTPUTS
    None
#>
function Remove-TfcPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Policy '$PolicyId'", "Delete")) {
        Write-Verbose "Removing policy: $PolicyId"
        Invoke-TfcApi -Uri "/policies/$PolicyId" -Method DELETE | Out-Null
        return $true
    }
}
