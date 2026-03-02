<#
.SYNOPSIS
    Removes a registry module
.DESCRIPTION
    Deletes a registry module from Terraform Cloud
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The module name
.PARAMETER Provider
    The provider name
.PARAMETER Force
    Skip confirmation prompt
.EXAMPLE
    Remove-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"
.OUTPUTS
    None
#>
function Remove-TfcRegistryModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Provider,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    $moduleId = "private/$Organization/$Name/$Provider"

    if ($Force -or $PSCmdlet.ShouldProcess("Registry Module '$moduleId'", "Delete")) {
        Write-Verbose "Deleting registry module: $moduleId"
        Invoke-TfcApi -Uri "/organizations/$Organization/registry-modules/$moduleId" -Method DELETE
        Write-Output "Registry module '$moduleId' has been deleted"
    }
}
