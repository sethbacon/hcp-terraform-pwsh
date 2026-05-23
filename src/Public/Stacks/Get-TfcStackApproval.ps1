<#
.SYNOPSIS
    Gets details for a stack approval
.DESCRIPTION
    Retrieves an approval record by ID. Approvals gate stack deployments that
    require manual sign-off before applying.
.PARAMETER StackApprovalId
    The stack approval ID
.EXAMPLE
    Get-TfcStackApproval -StackApprovalId "sa-abc123"
.OUTPUTS
    PSCustomObject representing the approval
#>
function Get-TfcStackApproval {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackApprovalId
    )

    Write-Verbose "Getting stack approval: $StackApprovalId"
    return Invoke-TfcApi -Uri "/stack-approvals/$StackApprovalId"
}
