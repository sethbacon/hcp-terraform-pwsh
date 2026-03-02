<#
.SYNOPSIS
    Gets organizations accessible to the current user
.DESCRIPTION
    Retrieves a list of organizations that the current user has access to
.PARAMETER Name
    Optional organization name to filter results
.PARAMETER AllPages
    Switch to retrieve all pages of results
.EXAMPLE
    Get-TfcOrganization
.EXAMPLE
    Get-TfcOrganization -Name "my-org"
.OUTPUTS
    PSCustomObject or array of PSCustomObjects representing organizations
#>
function Get-TfcOrganization {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    if ($Name) {
        Write-Verbose "Getting organization: $Name"
        return Invoke-TfcApi -Uri "/organizations/$Name"
    }
    else {
        Write-Verbose "Getting all organizations"
        return Invoke-TfcApi -Uri '/organizations' -AllPages:$AllPages
    }
}
