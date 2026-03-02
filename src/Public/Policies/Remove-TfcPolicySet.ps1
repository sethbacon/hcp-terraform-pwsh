<#
.SYNOPSIS
    Removes a policy set
.DESCRIPTION
    Deletes a policy set from the organization
.PARAMETER PolicySetId
    The policy set ID to remove
.EXAMPLE
    Remove-TfcPolicySet -PolicySetId "polset-123"
.OUTPUTS
    None
#>
function Remove-TfcPolicySet {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Policy Set '$PolicySetId'", "Delete")) {
        Write-Verbose "Removing policy set: $PolicySetId"
        Invoke-TfcApi -Uri "/policy-sets/$PolicySetId" -Method DELETE | Out-Null
        return $true
    }
}
