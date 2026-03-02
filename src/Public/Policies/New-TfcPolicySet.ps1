<#
.SYNOPSIS
    Creates a new policy set
.DESCRIPTION
    Creates a policy set to group policies and target workspaces or projects
.PARAMETER OrganizationName
    The organization name
.PARAMETER Name
    The policy set name
.PARAMETER Description
    Optional policy set description
.PARAMETER Global
    Whether this is a global policy set (applies to all workspaces)
.PARAMETER Kind
    Policy kind: sentinel or opa
.PARAMETER Overridable
    Whether policy checks can be overridden
.EXAMPLE
    New-TfcPolicySet -OrganizationName "my-org" -Name "production-policies" -Kind "sentinel"
.OUTPUTS
    PSCustomObject representing the created policy set
#>
function New-TfcPolicySet {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [string]$Description,
        [Parameter(Mandatory = $false)]
        [switch]$Global,
        [Parameter(Mandatory = $true)]
        [ValidateSet("sentinel", "opa")]
        [string]$Kind,
        [Parameter(Mandatory = $false)]
        [switch]$Overridable
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "policy-sets"
            attributes = @{
                name = $Name
                kind = $Kind
                global = $Global.IsPresent
                overridable = $Overridable.IsPresent
            }
        }
    }

    if ($Description) {
        $body.data.attributes.description = $Description
    }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Policy Set '$Name'", "Create")) {
        Write-Verbose "Creating policy set: $Name in organization $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/policy-sets" -Method POST -Body $jsonBody
    }
}
