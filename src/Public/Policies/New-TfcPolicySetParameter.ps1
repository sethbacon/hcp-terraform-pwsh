<#
.SYNOPSIS
    Creates a new policy set parameter
.DESCRIPTION
    Creates a new parameter for a policy set in Terraform Cloud
.PARAMETER PolicySetId
    The ID of the policy set to add the parameter to
.PARAMETER Key
    The parameter key/name
.PARAMETER Value
    The parameter value
.PARAMETER Category
    The parameter category: 'policy-set' (default)
.PARAMETER Sensitive
    Whether the parameter value is sensitive
.EXAMPLE
    New-TfcPolicySetParameter -PolicySetId "polset-123" -Key "environment" -Value "production"
.EXAMPLE
    New-TfcPolicySetParameter -PolicySetId "polset-123" -Key "api_key" -Value "secret123" -Sensitive
.OUTPUTS
    PSCustomObject representing the created policy set parameter
#>
function New-TfcPolicySetParameter {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,

        [Parameter(Mandatory = $true)]
        [string]$Key,

        [Parameter(Mandatory = $true)]
        [string]$Value,

        [Parameter(Mandatory = $false)]
        [ValidateSet('policy-set')]
        [string]$Category = 'policy-set',

        [Parameter(Mandatory = $false)]
        [switch]$Sensitive
    )

    if ($PSCmdlet.ShouldProcess("Policy Set $PolicySetId", "Create parameter '$Key'")) {
        $body = @{
            data = @{
                type = 'vars'
                attributes = @{
                    key = $Key
                    value = $Value
                    category = $Category
                    sensitive = $Sensitive.IsPresent
                }
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Creating policy set parameter: $Key"
        return Invoke-TfcApi -Uri "/policy-sets/$PolicySetId/parameters" -Method POST -Body $body
    }
}
