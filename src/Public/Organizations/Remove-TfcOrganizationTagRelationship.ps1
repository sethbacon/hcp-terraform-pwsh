function Remove-TfcOrganizationTagRelationship {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TagId,
        [Parameter(Mandatory = $true)]
        [string[]]$WorkspaceIds
    )

    Initialize-TfcConnection

    $body = @{
        data = @($WorkspaceIds | ForEach-Object {
            @{
                type = "workspaces"
                id = $_
            }
        })
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Tag '$TagId'", "Remove workspace relationships")) {
        Write-Verbose "Removing workspace relationships from tag: $TagId"
        return Invoke-TfcApi -Uri "/tags/$TagId/relationships/workspaces" -Method DELETE -Body $body
    }
}
