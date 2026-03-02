<#
.SYNOPSIS
    Gets HYOK key versions for a configuration
.DESCRIPTION
    Retrieves key versions associated with a HYOK configuration
.PARAMETER ConfigurationId
    The HYOK configuration ID
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcHYOKKeyVersion -ConfigurationId "hyok-abc123"
.OUTPUTS
    PSCustomObject representing HYOK key versions
#>
function Get-TfcHYOKKeyVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationId,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    $uri = "/hyok-configurations/$ConfigurationId/hyok-customer-key-versions?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
    Write-Verbose "Getting HYOK key versions for configuration: $ConfigurationId"
    return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
}
