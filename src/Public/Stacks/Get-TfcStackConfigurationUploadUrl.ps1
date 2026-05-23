<#
.SYNOPSIS
    Gets the upload URL for a stack configuration
.DESCRIPTION
    Retrieves the URL used to upload the source bundle for a stack configuration
.PARAMETER StackConfigurationId
    The stack configuration ID
.EXAMPLE
    Get-TfcStackConfigurationUploadUrl -StackConfigurationId "stackcfg-abc123"
.OUTPUTS
    PSCustomObject containing the upload URL
#>
function Get-TfcStackConfigurationUploadUrl {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackConfigurationId
    )

    Write-Verbose "Getting upload URL for stack configuration: $StackConfigurationId"
    return Invoke-TfcApi -Uri "/stack-configurations/$StackConfigurationId/upload-url"
}
