<#
.SYNOPSIS
    Overrides a policy check
.DESCRIPTION
    Overrides a soft-mandatory or advisory policy check to allow a run to proceed
.PARAMETER PolicyCheckId
    The policy check ID to override
.EXAMPLE
    Set-TfcPolicyCheckOverride -PolicyCheckId "polchk-123"
.OUTPUTS
    PSCustomObject representing the overridden policy check
#>
function Set-TfcPolicyCheckOverride {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyCheckId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Policy Check '$PolicyCheckId'", "Override")) {
        Write-Verbose "Overriding policy check: $PolicyCheckId"
        return Invoke-TfcApi -Uri "/policy-checks/$PolicyCheckId/actions/override" -Method POST
    }
}
