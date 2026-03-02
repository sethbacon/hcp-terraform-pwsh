<#
.SYNOPSIS
    Tests an existing HYOK configuration
.DESCRIPTION
    Tests connectivity for an existing Hold Your Own Key (HYOK) configuration
.PARAMETER ConfigurationId
    The ID of the HYOK configuration to test
.EXAMPLE
    Test-TfcHYOKConfiguration -ConfigurationId "hyokc-abc123"
.OUTPUTS
    PSCustomObject representing the test result
#>
function Test-TfcHYOKConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationId
    )

    Write-Verbose "Testing HYOK configuration: $ConfigurationId"
    return Invoke-TfcApi -Uri "/hyok-configurations/$ConfigurationId/actions/test" -Method POST
}
