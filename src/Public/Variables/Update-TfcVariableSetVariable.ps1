function Update-TfcVariableSetVariable {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,
        [Parameter(Mandatory = $true)]
        [string]$VariableId,
        [Parameter(Mandatory = $false)]
        [string]$Key,
        [Parameter(Mandatory = $false)]
        [string]$Value,
        [Parameter(Mandatory = $false)]
        [string]$Description,
        [Parameter(Mandatory = $false)]
        [ValidateSet('terraform', 'env')]
        [string]$Category,
        [Parameter(Mandatory = $false)]
        [bool]$Sensitive,
        [Parameter(Mandatory = $false)]
        [bool]$HCL
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "vars"
            id = $VariableId
            attributes = @{}
        }
    }

    if ($Key) { $body.data.attributes.key = $Key }
    if ($Value) { $body.data.attributes.value = $Value }
    if ($Description) { $body.data.attributes.description = $Description }
    if ($Category) { $body.data.attributes.category = $Category }
    if ($PSBoundParameters.ContainsKey('Sensitive')) { $body.data.attributes.sensitive = $Sensitive }
    if ($PSBoundParameters.ContainsKey('HCL')) { $body.data.attributes.hcl = $HCL }

    $requestBody = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Variable '$VariableId'", "Update variable in variable set '$VariableSetId'")) {
        Write-Verbose "Updating variable '$VariableId' in variable set: $VariableSetId"
        return Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/vars/$VariableId" -Method PATCH -Body $requestBody
    }
}
