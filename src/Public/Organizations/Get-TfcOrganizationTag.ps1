function Get-TfcOrganizationTag {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $false)]
        [string]$TagId
    )

    Initialize-TfcConnection

    if ($TagId) {
        Write-Verbose "Getting organization tag: $TagId"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/tags/$TagId" -Method GET
    } else {
        Write-Verbose "Listing all tags for organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/tags" -Method GET
    }
}
