<#
.SYNOPSIS
    Gets agent pools for an organization
.DESCRIPTION
    Retrieves agent pools used for self-hosted Terraform execution
.PARAMETER Organization
    The organization name
.PARAMETER AllPages
    Switch to retrieve all pages of results
.EXAMPLE
    Get-TfcAgentPool -Organization "my-org"
.OUTPUTS
    PSCustomObject representing agent pools
#>
function Get-TfcAgentPool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    Write-Verbose "Getting agent pools for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/agent-pools" -AllPages:$AllPages
}
