<#
.SYNOPSIS
    Removes a registry provider
.DESCRIPTION
    Deletes a registry provider from Terraform Cloud
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The provider name
.PARAMETER Force
    Skip confirmation prompt
.EXAMPLE
    Remove-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
.OUTPUTS
    None
#>
function Remove-TfcRegistryProvider {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    $providerId = "private/$Organization/$Name"

    if ($Force -or $PSCmdlet.ShouldProcess("Registry Provider '$providerId'", "Delete")) {
        Write-Verbose "Deleting registry provider: $providerId"
        Invoke-TfcApi -Uri "/organizations/$Organization/registry-providers/$providerId" -Method DELETE
        Write-Output "Registry provider '$providerId' has been deleted"
    }
}
