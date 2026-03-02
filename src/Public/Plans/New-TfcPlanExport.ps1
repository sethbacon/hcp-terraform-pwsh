<#
.SYNOPSIS
    Creates a plan export
.DESCRIPTION
    Creates an export of a plan for compliance and auditing
.PARAMETER PlanId
    The plan ID to export
.PARAMETER DataType
    Export data type: 'sentinel-mock-bundle-v0' or 'opa-bundle-v0'
.EXAMPLE
    New-TfcPlanExport -PlanId "plan-abc123" -DataType "sentinel-mock-bundle-v0"
.OUTPUTS
    PSCustomObject representing the plan export
#>
function New-TfcPlanExport {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PlanId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('sentinel-mock-bundle-v0', 'opa-bundle-v0')]
        [string]$DataType = 'sentinel-mock-bundle-v0'
    )

    $body = @{
        data = @{
            type = "plan-exports"
            attributes = @{
                'data-type' = $DataType
            }
            relationships = @{
                plan = @{
                    data = @{
                        type = "plans"
                        id = $PlanId
                    }
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating plan export for plan: $PlanId"
    if ($PSCmdlet.ShouldProcess("Plan: $PlanId", "Create plan export")) {
        return Invoke-TfcApi -Uri "/plan-exports" -Method POST -Body $body
    }
}
