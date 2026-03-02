<#
.SYNOPSIS
    Runs tests in parallel using PowerShell 7's ForEach-Object -Parallel.

.DESCRIPTION
    Executes test files in parallel for significantly faster test execution.
    Works with PowerShell 7+ without requiring specific Pester versions.

.PARAMETER TestPath
    Path to tests directory. Defaults to ./Unit

.PARAMETER ThrottleLimit
    Number of parallel threads. Defaults to processor count.

.PARAMETER Pattern
    File pattern to match. Defaults to "*.Tests.ps1"

.EXAMPLE
    .\Run-TestsParallel.ps1

.EXAMPLE
    .\Run-TestsParallel.ps1 -ThrottleLimit 4 -TestPath ./Unit
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$TestPath = "$PSScriptRoot/Unit",

    [Parameter()]
    [int]$ThrottleLimit = [System.Environment]::ProcessorCount,

    [Parameter()]
    [string]$Pattern = "*.Tests.ps1"
)

Write-Host "🚀 Starting parallel test execution..." -ForegroundColor Cyan
Write-Host "   Test Path: $TestPath" -ForegroundColor Gray
Write-Host "   Threads: $ThrottleLimit" -ForegroundColor Gray
Write-Host ""

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Get all test files
$testFiles = Get-ChildItem -Path $TestPath -Filter $Pattern -Recurse

Write-Host "📁 Found $($testFiles.Count) test files" -ForegroundColor Cyan
Write-Host ""

# Run tests in parallel
$results = $testFiles | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel {
    $testFile = $_

    # Run Pester for this file
    $container = New-PesterContainer -Path $testFile.FullName
    $config = New-PesterConfiguration
    $config.Run.Container = $container
    $config.Run.PassThru = $true
    $config.Output.Verbosity = 'None'

    try {
        $result = Invoke-Pester -Configuration $config
        return $result
    } catch {
        Write-Warning "Failed to run $($testFile.Name): $_"
        return $null
    }
}

$stopwatch.Stop()

# Aggregate results
$totalTests = ($results | Measure-Object -Property TotalCount -Sum).Sum
$passedTests = ($results | Measure-Object -Property PassedCount -Sum).Sum
$failedTests = ($results | Measure-Object -Property FailedCount -Sum).Sum
$skippedTests = ($results | Measure-Object -Property SkippedCount -Sum).Sum

$passRate = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 2) } else { 0 }

Write-Host ""
Write-Host ("=" * 80) -ForegroundColor Gray
Write-Host "📊 Test Results Summary" -ForegroundColor Cyan
Write-Host ("=" * 80) -ForegroundColor Gray
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
Write-Host "$($stopwatch.Elapsed.TotalSeconds.ToString('F2'))s" -ForegroundColor Cyan
Write-Host "Throughput:     $([math]::Round($totalTests / $stopwatch.Elapsed.TotalSeconds, 2)) tests/second" -ForegroundColor Cyan
Write-Host ""

# Show failed tests
if ($failedTests -gt 0) {
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host "❌ Failed Tests" -ForegroundColor Red
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host ""

    foreach ($result in $results) {
        if ($result.FailedCount -gt 0) {
            foreach ($test in $result.Failed) {
                Write-Host "  • $($test.ExpandedPath)" -ForegroundColor Yellow
                Write-Host "    $($test.ErrorRecord.Exception.Message)" -ForegroundColor Red
                Write-Host ""
            }
        }
    }
}

# Exit with appropriate code
if ($failedTests -gt 0) {
    exit 1
} else {
    exit 0
}
