function Remove-TfcOrganizationTag {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $true)]
        [string]$TagId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Tag '$TagId'", "Remove from organization '$OrganizationName'")) {
        Write-Verbose "Removing tag '$TagId' from organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/tags/$TagId" -Method DELETE
    }
}
