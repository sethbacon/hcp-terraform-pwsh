function Add-TfcOrganizationTagRelationship {
    [CmdletBinding(SupportsShouldProcess)]
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

    if ($PSCmdlet.ShouldProcess("Tag '$TagId'", "Add workspace relationships")) {
        Write-Verbose "Adding workspace relationships to tag: $TagId"
        return Invoke-TfcApi -Uri "/tags/$TagId/relationships/workspaces" -Method POST -Body $body
    }
}
