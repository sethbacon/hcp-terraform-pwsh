<#
.SYNOPSIS
    Update admin organization settings
.DESCRIPTION
    Updates administrative settings for Terraform Cloud (requires admin access)
.PARAMETER EnablePolicyEnforcement
    Enable or disable policy enforcement globally
.PARAMETER EnableCostEstimation
    Enable or disable cost estimation globally
.EXAMPLE
    Update-TfcAdminSettings -EnablePolicyEnforcement $true
#>
function Update-TfcAdminSettings {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $false)]
        [bool]$EnablePolicyEnforcement,
        [Parameter(Mandatory = $false)]
        [bool]$EnableCostEstimation
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "settings"
            attributes = @{}
        }
    }

    if ($PSBoundParameters.ContainsKey('EnablePolicyEnforcement')) {
        $body.data.attributes.'policy-enforcement' = $EnablePolicyEnforcement
    }

    if ($PSBoundParameters.ContainsKey('EnableCostEstimation')) {
        $body.data.attributes.'cost-estimation-enabled' = $EnableCostEstimation
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Admin Settings", "Update")) {
        Write-Verbose "Updating admin settings"
        return Invoke-TfcApi -Uri "/admin/settings" -Method PATCH -Body $bodyJson
    }
}
