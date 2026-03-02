<#
.SYNOPSIS
    Invokes the Terraform Cloud API
.DESCRIPTION
    A generic function for making API calls to Terraform Cloud
.PARAMETER Uri
    The API endpoint URI (relative to the base API URL)
.PARAMETER Method
    The HTTP method to use (GET, POST, PUT, PATCH, DELETE)
.PARAMETER Body
    The request body for POST/PUT/PATCH requests
.PARAMETER AllPages
    Switch to retrieve all pages for paginated responses
.EXAMPLE
    Invoke-TfcApi -Uri '/organizations' -Method GET
.EXAMPLE
    Invoke-TfcApi -Uri '/workspaces/ws-123/vars' -Method POST -Body $jsonBody
#>
function Invoke-TfcApi {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Uri,

        [Parameter(Mandatory = $false)]
        [ValidateSet('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
        [string]$Method = 'GET',

        [Parameter(Mandatory = $false)]
        [string]$Body,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    try {
        Initialize-TfcConnection

        $fullUri = if ($Uri.StartsWith('http')) { $Uri } else { "$script:TfcApiBaseUri$Uri" }

        $params = @{
            Uri = $fullUri
            Method = $Method
            Headers = $script:TfcHeaders
            Authentication = 'Bearer'
            Token = $script:TfcToken
        }

        if ($Body) {
            $params['Body'] = $Body
        }

        if ($AllPages -and $Method -eq 'GET') {
            return Get-AllPages -Uri $fullUri -Headers $script:TfcHeaders -Token $script:TfcToken
        }

        return Invoke-RestMethod @params
    }
    catch {
        $errorMessage = "API call failed: $($_.Exception.Message)"
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode
            $errorMessage += " (HTTP $statusCode)"
        }
        throw $errorMessage
    }
}
