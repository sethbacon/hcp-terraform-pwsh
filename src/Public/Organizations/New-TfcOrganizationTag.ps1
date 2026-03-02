function New-TfcOrganizationTag {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "tags"
            attributes = @{
                name = $Name
            }
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Organization '$OrganizationName'", "Create tag '$Name'")) {
        Write-Verbose "Creating tag '$Name' in organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/tags" -Method POST -Body $body
    }
}
