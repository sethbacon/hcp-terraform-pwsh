# TerraformCloud PowerShell Module - Getting Started Example
# Copyright (c) 2025 Seth T. Bacon. All rights reserved.
# Licensed under the MIT License.

<#
.SYNOPSIS
    Getting started example for the TerraformCloud PowerShell module
.DESCRIPTION
    This script demonstrates basic usage of the TerraformCloud module
.EXAMPLE
    .\Get-Started.ps1
#>

# Import the TerraformCloud module
Write-Host "Importing TerraformCloud module..." -ForegroundColor Green
Import-Module "$PSScriptRoot\TerraformCloud.psm1" -Force

# Check if authentication is configured
Write-Host "`nChecking authentication..." -ForegroundColor Green
if (-not $env:TFE_TOKEN -and -not (Test-Path ~/.terraform.d/credentials.tfrc.json)) {
    Write-Host "❌ No Terraform Cloud token found!" -ForegroundColor Red
    Write-Host "Please set your token using one of these methods:" -ForegroundColor Yellow
    Write-Host "  1. Environment variable: `$env:TFE_TOKEN = 'your-token-here'" -ForegroundColor Gray
    Write-Host "  2. Terraform CLI: terraform login" -ForegroundColor Gray
    Write-Host "  3. Manual file: ~/.terraform.d/credentials.tfrc.json" -ForegroundColor Gray
    exit 1
}

try {
    # Get current user information
    Write-Host "✅ Authentication successful!" -ForegroundColor Green
    $account = Get-TfcAccount
    Write-Host "Logged in as: $($account.data.attributes.username)" -ForegroundColor Cyan
    
    # List organizations
    Write-Host "`nFetching organizations..." -ForegroundColor Green
    $organizations = Get-TfcOrganization
    
    if ($organizations.data.Count -eq 0) {
        Write-Host "❌ No organizations found!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ Found $($organizations.data.Count) organization(s):" -ForegroundColor Green
    foreach ($org in $organizations.data) {
        Write-Host "  📁 $($org.attributes.name)" -ForegroundColor Cyan
        
        # Get workspaces for this organization
        try {
            $workspaces = Get-TfcWorkspace -Organization $org.attributes.name -PageSize 5
            Write-Host "     Workspaces: $($workspaces.data.Count)" -ForegroundColor Gray
            
            foreach ($workspace in $workspaces.data[0..2]) {  # Show first 3 workspaces
                Write-Host "       🏗️  $($workspace.attributes.name) (TF: $($workspace.attributes.'terraform-version'))" -ForegroundColor Gray
            }
            
            if ($workspaces.data.Count -gt 3) {
                Write-Host "       ... and $($workspaces.data.Count - 3) more" -ForegroundColor DarkGray
            }
        }
        catch {
            Write-Host "     ⚠️  Could not fetch workspaces: $($_.Exception.Message)" -ForegroundColor Yellow
        }
        Write-Host ""
    }
    
    # Example: Get entitlements for the first organization
    $firstOrg = $organizations.data[0].attributes.name
    Write-Host "Getting entitlements for organization '$firstOrg'..." -ForegroundColor Green
    
    try {
        $entitlements = Get-TfcOrganizationEntitlements -Organization $firstOrg
        Write-Host "✅ Organization Features:" -ForegroundColor Green
        
        $features = $entitlements.data.attributes
        $enabledFeatures = @()
        $disabledFeatures = @()
        
        foreach ($property in $features.PSObject.Properties) {
            if ($property.Value -eq $true) {
                $enabledFeatures += $property.Name
            }
            elseif ($property.Value -eq $false) {
                $disabledFeatures += $property.Name
            }
        }
        
        if ($enabledFeatures.Count -gt 0) {
            Write-Host "  🟢 Enabled: $($enabledFeatures -join ', ')" -ForegroundColor Green
        }
        
        if ($disabledFeatures.Count -gt 0) {
            Write-Host "  🔴 Disabled: $($disabledFeatures -join ', ')" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "⚠️  Could not fetch entitlements: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    Write-Host "`n🎉 Getting started example completed successfully!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "  • Explore workspaces: Get-TfcWorkspace -Organization '$firstOrg'" -ForegroundColor Gray
    Write-Host "  • Find workspaces: Find-TfcWorkspace -Organization '$firstOrg'" -ForegroundColor Gray
    Write-Host "  • Get help: Get-Help Get-TfcWorkspace -Full" -ForegroundColor Gray
    Write-Host "  • Run tests: .\Test-TerraformCloud.ps1 -TestOrganization '$firstOrg'" -ForegroundColor Gray
}
catch {
    Write-Host "❌ Error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Stack trace:" -ForegroundColor DarkRed
    Write-Host $_.ScriptStackTrace -ForegroundColor DarkRed
}
