<#
.SYNOPSIS
    Gets policy set parameters
.DESCRIPTION
    Retrieves parameters for a policy set in Terraform Cloud
.PARAMETER PolicySetId
    The ID of the policy set to get parameters for
.PARAMETER ParameterId
    Optional specific parameter ID to retrieve
.EXAMPLE
    Get-TfcPolicySetParameter -PolicySetId "polset-123"
.EXAMPLE
    Get-TfcPolicySetParameter -PolicySetId "polset-123" -ParameterId "param-456"
.OUTPUTS
    PSCustomObject or array of PSCustomObjects representing policy set parameters
#>
function Get-TfcPolicySetParameter {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,

        [Parameter(Mandatory = $false)]
        [string]$ParameterId
    )

    if ($ParameterId) {
        Write-Verbose "Getting policy set parameter: $ParameterId"
        return Invoke-TfcApi -Uri "/policy-set-parameters/$ParameterId"
    }
    else {
        Write-Verbose "Getting parameters for policy set: $PolicySetId"
        return Invoke-TfcApi -Uri "/policy-sets/$PolicySetId/parameters"
    }
}
