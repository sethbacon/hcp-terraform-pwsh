<#
.SYNOPSIS
    Downloads the source bundle for a stack configuration
.DESCRIPTION
    Retrieves the source bundle tarball for a stack configuration. If -OutputPath
    is provided, writes the bundle to disk; otherwise returns the raw bytes.
.PARAMETER StackConfigurationId
    The stack configuration ID
.PARAMETER OutputPath
    Optional file path to write the source bundle to
.EXAMPLE
    Save-TfcStackConfigurationSourceBundle -StackConfigurationId "stackcfg-abc123" -OutputPath ./bundle.tar.gz
.OUTPUTS
    The raw bytes if -OutputPath is not provided
#>
function Save-TfcStackConfigurationSourceBundle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackConfigurationId,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    Write-Verbose "Downloading source bundle for stack configuration: $StackConfigurationId"
    $result = Invoke-TfcApi -Uri "/stack-configurations/$StackConfigurationId/source-bundle"

    if ($OutputPath) {
        if ($result -is [byte[]]) {
            [System.IO.File]::WriteAllBytes($OutputPath, $result)
        } else {
            $result | Out-File -FilePath $OutputPath -Encoding UTF8
        }
        Write-Output "Source bundle saved to: $OutputPath"
    } else {
        return $result
    }
}
