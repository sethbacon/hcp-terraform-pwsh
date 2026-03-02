<#
.SYNOPSIS
    Runs TerraformCloud module tests with parallel execution support.

.DESCRIPTION
    Executes Pester tests with configurable parallelization for improved performance.
    Supports unit tests, integration tests, mock mode, and various execution options.

.PARAMETER Path
    Path(s) to test files or directories. Defaults to Tests/Unit and Tests/Integration.

.PARAMETER Tag
    Only run tests with specified tags (e.g., 'Unit', 'Fast', 'Read').

.PARAMETER ExcludeTag
    Exclude tests with specified tags (e.g., 'Slow', 'Destructive').

.PARAMETER Parallel
    Enable parallel test execution. Default is $true for better performance.

.PARAMETER ThrottleLimit
    Maximum number of parallel threads. Defaults to processor count.

.PARAMETER MockMode
    Run tests in mock mode (no API calls). Recommended for unit tests.

.PARAMETER TestOrganization
    Name of test organization in TFC/TFE. Required for live API integration tests.

.PARAMETER RunDestructiveTests
    Enable tests that create/delete resources. Requires confirmation.

.PARAMETER OutputFormat
    Test result output format: 'Detailed', 'Normal', 'Minimal', 'None'.

.PARAMETER CI
    Configure for CI/CD environment (NUnit XML output, appropriate verbosity).

.PARAMETER CodeCoverage
    Enable code coverage analysis.

.PARAMETER PassThru
    Return detailed test results object.

.EXAMPLE
    .\Run-ParallelTests.ps1
    Runs all tests with default parallel execution.

.EXAMPLE
    .\Run-ParallelTests.ps1 -Tag 'Unit', 'Fast' -Parallel
    Runs only fast unit tests in parallel.

.EXAMPLE
    .\Run-ParallelTests.ps1 -MockMode -Tag 'Unit'
    Runs unit tests in mock mode (no API calls).

.EXAMPLE
    .\Run-ParallelTests.ps1 -Path ./Tests/Integration -Parallel:$false -TestOrganization 'test-org'
    Runs integration tests sequentially against test organization.

.EXAMPLE
    .\Run-ParallelTests.ps1 -CI -CodeCoverage
    Runs tests in CI mode with code coverage (suitable for Azure DevOps).

.NOTES
    Version: 1.0.0
    Author: TerraformCloud Module Team
    Requires: Pester 5.0+
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string[]]$Path = @("$PSScriptRoot/Unit", "$PSScriptRoot/Integration"),

    [Parameter()]
    [string[]]$Tag,

    [Parameter()]
    [string[]]$ExcludeTag,

    [Parameter()]
    [bool]$Parallel = $true,

    [Parameter()]
    [int]$ThrottleLimit = [System.Environment]::ProcessorCount,

    [Parameter()]
    [switch]$MockMode,

    [Parameter()]
    [string]$TestOrganization,

    [Parameter()]
    [switch]$RunDestructiveTests,

    [Parameter()]
    [ValidateSet('Detailed', 'Normal', 'Minimal', 'None')]
    [string]$OutputFormat = 'Detailed',

    [Parameter()]
    [switch]$CI,

    [Parameter()]
    [switch]$CodeCoverage,

    [Parameter()]
    [switch]$PassThru
)

#region Prerequisites Check
Write-Host "🔍 Checking prerequisites..." -ForegroundColor Cyan

# Check Pester version
$pesterVersion = (Get-Module -Name Pester -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1).Version
if ($pesterVersion.Major -lt 5) {
    Write-Host "❌ Pester 5.0+ is required. Current version: $pesterVersion" -ForegroundColor Red
    Write-Host "   Install with: Install-Module Pester -MinimumVersion 5.0 -Force -SkipPublisherCheck" -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✓ Pester $pesterVersion" -ForegroundColor Green

# Check if module is available
$modulePath = Split-Path $PSScriptRoot -Parent
if (-not (Test-Path "$modulePath/TerraformCloud.psd1")) {
    Write-Host "❌ TerraformCloud module not found at: $modulePath" -ForegroundColor Red
    exit 1
}
Write-Host "   ✓ TerraformCloud module found" -ForegroundColor Green

# Import module for testing
Import-Module "$modulePath/TerraformCloud.psd1" -Force -ErrorAction Stop
Write-Host "   ✓ Module imported successfully" -ForegroundColor Green
#endregion

#region Safety Checks
if (-not $MockMode -and $TestOrganization) {
    Write-Host "`n⚠️  Running tests against live API: $TestOrganization" -ForegroundColor Yellow

    # Check if organization name looks like a test org
    if ($TestOrganization -notmatch '(test|demo|sandbox|dev)') {
        Write-Host "❌ Organization name does not contain 'test', 'demo', 'sandbox', or 'dev'" -ForegroundColor Red
        Write-Host "   This safety check prevents accidental testing against production." -ForegroundColor Yellow
        Write-Host "   To override, rename your test organization to include one of these terms." -ForegroundColor Yellow

        $confirmation = Read-Host "   Continue anyway? (yes/no)"
        if ($confirmation -ne 'yes') {
            Write-Host "   Test execution cancelled." -ForegroundColor Yellow
            exit 0
        }
    }
}

if ($RunDestructiveTests -and -not $MockMode) {
    Write-Host "`n⚠️  Destructive tests enabled - will create and delete resources!" -ForegroundColor Yellow
    $confirmation = Read-Host "   Are you sure? (yes/no)"
    if ($confirmation -ne 'yes') {
        Write-Host "   Destructive tests disabled." -ForegroundColor Yellow
        $RunDestructiveTests = $false
    }
}
#endregion

#region Configuration
Write-Host "`n⚙️  Configuring test execution..." -ForegroundColor Cyan

# Create Pester configuration
$config = New-PesterConfiguration

# Test discovery
$config.Run.Path = $Path
$config.Run.PassThru = $true

# Parallel execution
$config.Run.Parallel = $Parallel
if ($Parallel) {
    $config.Run.ParallelExecutionThrottle = $ThrottleLimit
    Write-Host "   ✓ Parallel execution enabled ($ThrottleLimit threads)" -ForegroundColor Green
} else {
    Write-Host "   ✓ Sequential execution" -ForegroundColor Green
}

# Tag filtering
if ($Tag) {
    $config.Filter.Tag = $Tag
    Write-Host "   ✓ Including tags: $($Tag -join ', ')" -ForegroundColor Green
}
if ($ExcludeTag) {
    $config.Filter.ExcludeTag = $ExcludeTag
    Write-Host "   ✓ Excluding tags: $($ExcludeTag -join ', ')" -ForegroundColor Green
}

# Output configuration
$config.Output.Verbosity = $OutputFormat
Write-Host "   ✓ Output verbosity: $OutputFormat" -ForegroundColor Green

# CI/CD configuration
if ($CI) {
    $config.Output.CIFormat = 'Auto'
    $config.TestResult.Enabled = $true
    $config.TestResult.OutputFormat = 'NUnitXml'
    $config.TestResult.OutputPath = "$PSScriptRoot/TestResults.xml"
    Write-Host "   ✓ CI mode enabled (NUnit XML output)" -ForegroundColor Green
}

# Code coverage
if ($CodeCoverage) {
    $config.CodeCoverage.Enabled = $true
    $config.CodeCoverage.Path = "$modulePath/*.ps1", "$modulePath/*.psm1"
    $config.CodeCoverage.OutputPath = "$PSScriptRoot/Coverage.xml"
    $config.CodeCoverage.OutputFormat = 'JaCoCo'
    Write-Host "   ✓ Code coverage enabled" -ForegroundColor Green
}

# Test environment variables
if ($MockMode) {
    $env:PESTER_MOCK_MODE = 'true'
    Write-Host "   ✓ Mock mode enabled" -ForegroundColor Green
}
if ($TestOrganization) {
    $env:PESTER_TEST_ORGANIZATION = $TestOrganization
    Write-Host "   ✓ Test organization: $TestOrganization" -ForegroundColor Green
}
if ($RunDestructiveTests) {
    $env:PESTER_RUN_DESTRUCTIVE_TESTS = 'true'
    Write-Host "   ✓ Destructive tests enabled" -ForegroundColor Yellow
}
#endregion

#region Execute Tests
Write-Host "`n🚀 Executing tests..." -ForegroundColor Cyan
Write-Host ("=" * 80) -ForegroundColor Gray

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

try {
    $results = Invoke-Pester -Configuration $config
} catch {
    Write-Host "`n❌ Test execution failed: $_" -ForegroundColor Red
    exit 1
} finally {
    $stopwatch.Stop()
}
#endregion

#region Results Summary
Write-Host ""
Write-Host ("=" * 80) -ForegroundColor Gray
Write-Host "📊 Test Results Summary" -ForegroundColor Cyan
Write-Host ("=" * 80) -ForegroundColor Gray

$totalTests = $results.TotalCount
$passedTests = $results.PassedCount
$failedTests = $results.FailedCount
$skippedTests = $results.SkippedCount
$notRunTests = $results.NotRunCount
$executionTime = $stopwatch.Elapsed

# Calculate pass rate
$passRate = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 2) } else { 0 }

Write-Host ""
Write-Host "Total Tests:    $totalTests" -ForegroundColor White
Write-Host "Passed:         " -NoNewline
Write-Host "$passedTests" -ForegroundColor Green
Write-Host "Failed:         " -NoNewline
if ($failedTests -gt 0) {
    Write-Host "$failedTests" -ForegroundColor Red
} else {
    Write-Host "$failedTests" -ForegroundColor Green
}
Write-Host "Skipped:        $skippedTests" -ForegroundColor Yellow
Write-Host "Not Run:        $notRunTests" -ForegroundColor Gray
Write-Host ""
Write-Host "Pass Rate:      " -NoNewline
if ($passRate -eq 100) {
    Write-Host "$passRate%" -ForegroundColor Green
} elseif ($passRate -ge 90) {
    Write-Host "$passRate%" -ForegroundColor Yellow
} else {
    Write-Host "$passRate%" -ForegroundColor Red
}
Write-Host "Execution Time: " -NoNewline
Write-Host "$($executionTime.TotalSeconds.ToString('F2'))s" -ForegroundColor Cyan

# Performance metrics
if ($Parallel -and $totalTests -gt 0) {
    $testsPerSecond = [math]::Round($totalTests / $executionTime.TotalSeconds, 2)
    Write-Host "Throughput:     $testsPerSecond tests/second" -ForegroundColor Cyan
}

Write-Host ""

# Code coverage summary
if ($CodeCoverage -and $results.CodeCoverage) {
    $coverage = $results.CodeCoverage
    $coveragePercent = if ($coverage.CoveredPercent) { $coverage.CoveredPercent } else { 0 }

    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host "📈 Code Coverage" -ForegroundColor Cyan
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host ""
    Write-Host "Coverage:       " -NoNewline
    if ($coveragePercent -ge 80) {
        Write-Host "$([math]::Round($coveragePercent, 2))%" -ForegroundColor Green
    } elseif ($coveragePercent -ge 60) {
        Write-Host "$([math]::Round($coveragePercent, 2))%" -ForegroundColor Yellow
    } else {
        Write-Host "$([math]::Round($coveragePercent, 2))%" -ForegroundColor Red
    }
    Write-Host "Commands Hit:   $($coverage.CommandsExecutedCount)" -ForegroundColor White
    Write-Host "Commands Total: $($coverage.CommandsAnalyzedCount)" -ForegroundColor White
    Write-Host ""
}

# Failed test details
if ($failedTests -gt 0) {
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host "❌ Failed Tests" -ForegroundColor Red
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host ""

    foreach ($test in $results.Failed) {
        Write-Host "  • $($test.ExpandedPath)" -ForegroundColor Yellow
        Write-Host "    $($test.ErrorRecord.Exception.Message)" -ForegroundColor Red
        Write-Host ""
    }
}

# Performance recommendations
if ($executionTime.TotalSeconds -gt 30 -and -not $Parallel) {
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host "💡 Performance Recommendation" -ForegroundColor Yellow
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Tests took $($executionTime.TotalSeconds.ToString('F2'))s in sequential mode." -ForegroundColor Yellow
    Write-Host "  Consider running with -Parallel for faster execution:" -ForegroundColor Yellow
    Write-Host "  .\Run-ParallelTests.ps1 -Parallel" -ForegroundColor Cyan
    Write-Host ""
}
#endregion

#region Cleanup
# Clear environment variables
Remove-Item Env:PESTER_MOCK_MODE -ErrorAction SilentlyContinue
Remove-Item Env:PESTER_TEST_ORGANIZATION -ErrorAction SilentlyContinue
Remove-Item Env:PESTER_RUN_DESTRUCTIVE_TESTS -ErrorAction SilentlyContinue
#endregion

#region Exit Code
if ($PassThru) {
    return $results
}

# Exit with appropriate code
if ($failedTests -gt 0) {
    exit 1
} else {
    exit 0
}
#endregion
