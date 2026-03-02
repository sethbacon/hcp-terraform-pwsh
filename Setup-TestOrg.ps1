#!/usr/bin/env pwsh
# Terraform Cloud Test Organization Setup Helper
# Copyright (c) 2025 Seth T. Bacon. All rights reserved.
# Licensed under MIT License.

<#
.SYNOPSIS
    Helps set up and validate a Terraform Cloud test organization for safe testing
.DESCRIPTION
    This script guides you through creating and configuring a test organization,
    setting up API tokens, and validating the test environment.
.PARAMETER TestOrgName
    Name of the test organization to create/validate
.PARAMETER SetupMode
    Setup mode: 'create', 'validate', or 'guide'
.EXAMPLE
    .\Setup-TestOrg.ps1 -SetupMode guide
.EXAMPLE
    .\Setup-TestOrg.ps1 -TestOrgName "mycompany-test" -SetupMode validate
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$TestOrgName = "",
    
    [Parameter(Mandatory = $false)]
    [ValidateSet('create', 'validate', 'guide')]
    [string]$SetupMode = 'guide'
)

function Write-StepHeader {
    param([string]$Step, [string]$Description)
    Write-Host "`n🔧 Step $Step" -ForegroundColor Cyan
    Write-Host $Description -ForegroundColor White
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "💡 $Message" -ForegroundColor Blue
}

Write-Host "=== Terraform Cloud Test Organization Setup ===" -ForegroundColor Green

switch ($SetupMode) {
    'guide' {
        Write-Host "This guide will help you set up a safe testing environment." -ForegroundColor White
        
        Write-StepHeader "1" "Create Terraform Cloud Test Organization"
        Write-Host "1. Go to https://app.terraform.io" -ForegroundColor Gray
        Write-Host "2. Sign in to your account (or create a new one)" -ForegroundColor Gray
        Write-Host "3. Click 'Create Organization'" -ForegroundColor Gray
        Write-Host "4. Use a clear test name like:" -ForegroundColor Gray
        Write-Host "   - {yourname}-test-org" -ForegroundColor Yellow
        Write-Host "   - {company}-testing" -ForegroundColor Yellow
        Write-Host "   - {project}-test-2025" -ForegroundColor Yellow
        Write-Warning "Avoid production-like names!"
        
        Write-StepHeader "2" "Generate API Token"
        Write-Host "1. In your new test organization, go to Settings → API Tokens" -ForegroundColor Gray
        Write-Host "2. Click 'Create API Token'" -ForegroundColor Gray
        Write-Host "3. Name it something like 'PowerShell-Module-Testing'" -ForegroundColor Gray
        Write-Host "4. Copy the token (you won't see it again!)" -ForegroundColor Gray
        
        Write-StepHeader "3" "Set Environment Variable"
        Write-Host "PowerShell:" -ForegroundColor Gray
        Write-Host '   $env:TFE_TOKEN = "your-token-here"' -ForegroundColor Yellow
        Write-Host "Bash/Zsh:" -ForegroundColor Gray
        Write-Host '   export TFE_TOKEN="your-token-here"' -ForegroundColor Yellow
        
        Write-StepHeader "4" "Test the Setup"
        $testOrgName = Read-Host "Enter your test organization name"
        if ($testOrgName) {
            Write-Host "Run this command to test:" -ForegroundColor Gray
            Write-Host "   ./Test-Extended.ps1 -UseTestOrganization -TestOrganizationName '$testOrgName'" -ForegroundColor Yellow
        }
    }
    
    'validate' {
        Write-Host "Validating test organization setup..." -ForegroundColor White
        
        # Check for API token
        if (-not $env:TFE_TOKEN) {
            Write-Error "TFE_TOKEN environment variable not set"
            Write-Info "Set it with: `$env:TFE_TOKEN = 'your-token'"
            return
        }
        Write-Success "TFE_TOKEN environment variable is set"
        
        # Check if module can be loaded
        try {
            Import-Module ./TerraformCloud.psd1 -Force
            Write-Success "TerraformCloud module loaded successfully"
        }
        catch {
            Write-Error "Failed to load TerraformCloud module: $($_.Exception.Message)"
            return
        }
        
        # Test authentication
        try {
            $account = Get-TfcAccount
            Write-Success "Authentication successful - User: $($account.data.attributes.username)"
        }
        catch {
            Write-Error "Authentication failed: $($_.Exception.Message)"
            return
        }
        
        # Test organization access
        if ($TestOrgName) {
            try {
                $org = Get-TfcOrganization -Name $TestOrgName
                if ($org.data.id) {
                    Write-Success "Test organization '$TestOrgName' found and accessible"
                    Write-Info "Organization ID: $($org.data.id)"
                }
                else {
                    Write-Error "Test organization '$TestOrgName' not found"
                }
            }
            catch {
                Write-Error "Failed to access test organization '$TestOrgName': $($_.Exception.Message)"
            }
        }
        else {
            Write-Warning "No test organization name provided - use -TestOrgName parameter"
        }
        
        Write-StepHeader "Next" "Run Tests"
        if ($TestOrgName) {
            Write-Host "Mock Mode (Safe):        ./Test-Extended.ps1 -MockMode" -ForegroundColor Yellow
            Write-Host "Test Organization:       ./Test-Extended.ps1 -UseTestOrganization -TestOrganizationName '$TestOrgName'" -ForegroundColor Yellow
            Write-Host "With Destructive Tests:  ./Test-Extended.ps1 -UseTestOrganization -TestOrganizationName '$TestOrgName' -SkipDestructiveTests:`$false" -ForegroundColor Yellow
        }
    }
    
    'create' {
        Write-Host "Automated test organization creation is not yet implemented." -ForegroundColor Yellow
        Write-Host "Please use -SetupMode guide for manual setup instructions." -ForegroundColor Gray
    }
}

Write-Host "`n📚 Additional Resources:" -ForegroundColor Cyan
Write-Host "- Terraform Cloud Documentation: https://developer.hashicorp.com/terraform/cloud-docs" -ForegroundColor Gray
Write-Host "- API Documentation: https://developer.hashicorp.com/terraform/cloud-docs/api-docs" -ForegroundColor Gray
Write-Host "- Testing Guide: See TESTING.md in this directory" -ForegroundColor Gray

Write-Host "`n💡 Pro Tips:" -ForegroundColor Cyan
Write-Host "- Keep test and production tokens separate" -ForegroundColor Gray
Write-Host "- Use descriptive names for test organizations" -ForegroundColor Gray
Write-Host "- Always start with mock mode for development" -ForegroundColor Gray
Write-Host "- Review test results before running destructive tests" -ForegroundColor Gray
