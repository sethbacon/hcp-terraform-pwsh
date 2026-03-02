<#
.SYNOPSIS
    Adds policies to a policy set
.DESCRIPTION
    Attaches one or more policies to a policy set
.PARAMETER PolicySetId
    The policy set ID
.PARAMETER PolicyIds
    Array of policy IDs to add
.EXAMPLE
    Add-TfcPolicySetPolicy -PolicySetId "polset-123" -PolicyIds @("pol-1", "pol-2")
.OUTPUTS
    None
#>
function Add-TfcPolicySetPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,
        [Parameter(Mandatory = $true)]
        [string[]]$PolicyIds
    )

    Initialize-TfcConnection

    $relationships = $PolicyIds | ForEach-Object {
        @{
            type = "policies"
            id = $_
        }
    }

    $body = @{
        data = $relationships
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Policy Set '$PolicySetId'", "Add policies")) {
        Write-Verbose "Adding $($PolicyIds.Count) policies to policy set: $PolicySetId"
        Invoke-TfcApi -Uri "/policy-sets/$PolicySetId/relationships/policies" -Method POST -Body $body | Out-Null
        return $true
    }
}
