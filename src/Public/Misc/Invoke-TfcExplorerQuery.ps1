<#
.SYNOPSIS
    Execute a GraphQL explorer query
.DESCRIPTION
    Executes a GraphQL query against the Terraform Cloud API
.PARAMETER Query
    The GraphQL query to execute
.PARAMETER Variables
    Optional variables for the GraphQL query
.EXAMPLE
    Invoke-TfcExplorerQuery -Query "query { organization(name: \"my-org\") { name } }"
#>
function Invoke-TfcExplorerQuery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Query,
        [Parameter(Mandatory = $false)]
        [hashtable]$Variables
    )

    Initialize-TfcConnection

    $body = @{
        query = $Query
    }

    if ($Variables) {
        $body.variables = $Variables
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    Write-Verbose "Executing GraphQL query"
    return Invoke-TfcApi -Uri "/explorer/graphql" -Method POST -Body $bodyJson
}
