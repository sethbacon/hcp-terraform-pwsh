function New-TfcVariableSetVariable {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,
        [Parameter(Mandatory = $true)]
        [string]$Key,
        [Parameter(Mandatory = $true)]
        [string]$Value,
        [Parameter(Mandatory = $false)]
        [string]$Description,
        [Parameter(Mandatory = $false)]
        [ValidateSet('terraform', 'env')]
        [string]$Category = 'terraform',
        [Parameter(Mandatory = $false)]
        [bool]$Sensitive = $false,
        [Parameter(Mandatory = $false)]
        [bool]$HCL = $false
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "vars"
            attributes = @{
                key = $Key
                value = $Value
                category = $Category
                sensitive = $Sensitive
                hcl = $HCL
            }
        }
    }

    if ($Description) {
        $body.data.attributes.description = $Description
    }

    $requestBody = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Variable Set '$VariableSetId'", "Create variable '$Key'")) {
        Write-Verbose "Creating variable '$Key' in variable set: $VariableSetId"
        return Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/vars" -Method POST -Body $requestBody
    }
}
