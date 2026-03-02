<#
.SYNOPSIS
    Removes a policy set parameter
.DESCRIPTION
    Deletes a parameter from a policy set in Terraform Cloud
.PARAMETER ParameterId
    The ID of the parameter to remove
.EXAMPLE
    Remove-TfcPolicySetParameter -ParameterId "param-123"
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcPolicySetParameter {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ParameterId
    )

    if ($PSCmdlet.ShouldProcess("Parameter $ParameterId", "Delete policy set parameter")) {
        Write-Verbose "Deleting policy set parameter: $ParameterId"
        try {
            Invoke-TfcApi -Uri "/policy-set-parameters/$ParameterId" -Method DELETE
            return $true
        }
        catch {
            Write-Error "Failed to delete policy set parameter: $_"
            return $false
        }
    }
}
