<#
.SYNOPSIS
    Updates a policy set parameter
.DESCRIPTION
    Updates an existing parameter for a policy set in Terraform Cloud
.PARAMETER ParameterId
    The ID of the parameter to update
.PARAMETER Key
    The new parameter key/name
.PARAMETER Value
    The new parameter value
.PARAMETER Sensitive
    Whether the parameter value is sensitive
.EXAMPLE
    Update-TfcPolicySetParameter -ParameterId "param-123" -Value "new-value"
.EXAMPLE
    Update-TfcPolicySetParameter -ParameterId "param-123" -Key "new-key" -Value "new-value" -Sensitive
.OUTPUTS
    PSCustomObject representing the updated policy set parameter
#>
function Update-TfcPolicySetParameter {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ParameterId,

        [Parameter(Mandatory = $false)]
        [string]$Key,

        [Parameter(Mandatory = $false)]
        [string]$Value,

        [Parameter(Mandatory = $false)]
        [switch]$Sensitive
    )

    if ($PSCmdlet.ShouldProcess("Parameter $ParameterId", "Update policy set parameter")) {
        $attributes = @{}

        if ($Key) { $attributes['key'] = $Key }
        if ($Value) { $attributes['value'] = $Value }
        if ($PSBoundParameters.ContainsKey('Sensitive')) {
            $attributes['sensitive'] = $Sensitive.IsPresent
        }

        $body = @{
            data = @{
                type = 'vars'
                id = $ParameterId
                attributes = $attributes
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Updating policy set parameter: $ParameterId"
        return Invoke-TfcApi -Uri "/policy-set-parameters/$ParameterId" -Method PATCH -Body $body
    }
}
