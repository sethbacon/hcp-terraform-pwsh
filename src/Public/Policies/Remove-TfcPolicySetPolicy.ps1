<#
.SYNOPSIS
    Removes a policy from a policy set
.DESCRIPTION
    Detaches/removes a policy from a policy set in Terraform Cloud
.PARAMETER PolicySetId
    The ID of the policy set to remove the policy from
.PARAMETER PolicyId
    The ID of the policy to remove from the set
.EXAMPLE
    Remove-TfcPolicySetPolicy -PolicySetId "polset-123" -PolicyId "pol-456"
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcPolicySetPolicy {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,

        [Parameter(Mandatory = $true)]
        [string]$PolicyId
    )

    if ($PSCmdlet.ShouldProcess("Policy Set $PolicySetId", "Remove policy $PolicyId")) {
        $body = @{
            data = @(
                @{
                    type = 'policies'
                    id = $PolicyId
                }
            )
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Removing policy $PolicyId from policy set $PolicySetId"
        try {
            Invoke-TfcApi -Uri "/policy-sets/$PolicySetId/relationships/policies" -Method DELETE -Body $body
            return $true
        }
        catch {
            Write-Error "Failed to remove policy from policy set: $_"
            return $false
        }
    }
}
