# Test Runner for TerraformCloud Module
# Runs all Pester tests with coverage and reporting

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet('All', 'Unit', 'Integration', 'Category')]
    [string]$TestType = 'All',

    [Parameter(Mandatory = $false)]
    [string]$Category,

    [Parameter(Mandatory = $false)]
    [switch]$Coverage,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = './TestResults',

    [Parameter(Mandatory = $false)]
    [switch]$FailOnWarning
)

#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

$ErrorActionPreference = 'Stop'

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TerraformCloud Module Test Runner" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Set paths
$testsPath = $PSScriptRoot
$modulePath = Join-Path $testsPath '..' 'Output' 'TerraformCloud'
$unitTestsPath = Join-Path $testsPath 'Unit'
$integrationTestsPath = Join-Path $testsPath 'Integration'

# Ensure output directory exists
if (-not (Test-Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
}

# Build test configuration
$pesterConfig = @{
    Run = @{
        Path = @()
        PassThru = $true
    }
    Output = @{
        Verbosity = 'Detailed'
    }
    TestResult = @{
        Enabled = $true
        OutputPath = Join-Path $OutputPath 'TestResults.xml'
        OutputFormat = 'NUnitXml'
    }
}

# Determine which tests to run
switch ($TestType) {
    'All' {
        Write-Host "Running all tests (Unit + Integration)..." -ForegroundColor Green
        $pesterConfig.Run.Path += $unitTestsPath
        $pesterConfig.Run.Path += $integrationTestsPath
    }
    'Unit' {
        Write-Host "Running unit tests..." -ForegroundColor Green
        $pesterConfig.Run.Path += $unitTestsPath
    }
    'Integration' {
        Write-Host "Running integration tests..." -ForegroundColor Green
        $pesterConfig.Run.Path += $integrationTestsPath
    }
    'Category' {
        if (-not $Category) {
            throw "Category parameter is required when TestType is 'Category'"
        }
        Write-Host "Running tests for category: $Category..." -ForegroundColor Green
        $categoryPath = Join-Path $unitTestsPath $Category
        if (-not (Test-Path $categoryPath)) {
            throw "Category '$Category' not found at $categoryPath"
        }
        $pesterConfig.Run.Path += $categoryPath
    }
}

# Add code coverage if requested
if ($Coverage) {
    Write-Host "Code coverage analysis enabled" -ForegroundColor Yellow
    $pesterConfig.CodeCoverage = @{
        Enabled = $true
        Path = Join-Path $modulePath 'TerraformCloud.psm1'
        OutputPath = Join-Path $OutputPath 'Coverage.xml'
        OutputFormat = 'JaCoCo'
    }
}

Write-Host ""
Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  Test Paths: $($pesterConfig.Run.Path -join ', ')" -ForegroundColor Gray
Write-Host "  Output Path: $OutputPath" -ForegroundColor Gray
Write-Host "  Coverage: $Coverage" -ForegroundColor Gray
Write-Host ""

# Run tests
$config = New-PesterConfiguration -Hashtable $pesterConfig
$result = Invoke-Pester -Configuration $config

# Display results
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Test Results Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Total Tests:  $($result.TotalCount)" -ForegroundColor White
Write-Host "  Passed:       $($result.PassedCount)" -ForegroundColor Green
Write-Host "  Failed:       $($result.FailedCount)" -ForegroundColor $(if ($result.FailedCount -gt 0) { 'Red' } else { 'Green' })
Write-Host "  Skipped:      $($result.SkippedCount)" -ForegroundColor Yellow
Write-Host "  Duration:     $($result.Duration)" -ForegroundColor Gray

if ($Coverage -and $result.CodeCoverage) {
    $coveredPercent = [math]::Round(($result.CodeCoverage.CoveredPercent), 2)
    Write-Host ""
    Write-Host "  Code Coverage:" -ForegroundColor Cyan
    Write-Host "    Covered:    $($result.CodeCoverage.CoveredCommands) / $($result.CodeCoverage.TotalCommands) commands" -ForegroundColor White
    Write-Host "    Percentage: $coveredPercent%" -ForegroundColor $(if ($coveredPercent -ge 80) { 'Green' } elseif ($coveredPercent -ge 60) { 'Yellow' } else { 'Red' })
}

Write-Host ""

# Return appropriate exit code
if ($result.FailedCount -gt 0) {
    Write-Host "❌ Tests FAILED" -ForegroundColor Red
    exit 1
}

if ($FailOnWarning -and $result.SkippedCount -gt 0) {
    Write-Host "⚠️  Tests had warnings (skipped tests)" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ All tests PASSED" -ForegroundColor Green
exit 0
