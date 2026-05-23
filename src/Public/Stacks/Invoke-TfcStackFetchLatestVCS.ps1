<#
.SYNOPSIS
    Fetches the latest stack configuration from VCS
.DESCRIPTION
    Triggers HCP Terraform to fetch the latest stack configuration from the
    connected VCS provider.
.PARAMETER StackId
    The stack ID
.EXAMPLE
    Invoke-TfcStackFetchLatestVCS -StackId "stack-abc123"
.OUTPUTS
    PSCustomObject representing the new stack configuration
#>
function Invoke-TfcStackFetchLatestVCS {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId
    )

    Write-Verbose "Fetching latest VCS configuration for stack: $StackId"
    if ($PSCmdlet.ShouldProcess("Stack: $StackId", "Fetch latest from VCS")) {
        return Invoke-TfcApi -Uri "/stacks/$StackId/fetch-latest-from-vcs" -Method POST
    }
}
