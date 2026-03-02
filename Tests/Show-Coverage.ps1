[xml]$xml = Get-Content ./TestResults/Coverage.xml

$counters = $xml.report.counter

Write-Host "`n=== Code Coverage Summary ===" -ForegroundColor Cyan
Write-Host ""

foreach($c in $counters) {
    $covered = [int]$c.covered
    $missed = [int]$c.missed
    $total = $covered + $missed
    $percent = if ($total -gt 0) { [math]::Round($covered / $total * 100, 2) } else { 0 }

    $color = if ($percent -ge 80) { 'Green' } elseif ($percent -ge 60) { 'Yellow' } else { 'Red' }

    Write-Host ("  {0,-15}: " -f $c.type) -NoNewline
    Write-Host ("{0,5}/{1,-5} " -f $covered, $total) -NoNewline
    Write-Host ("({0:N2}%)" -f $percent) -ForegroundColor $color
}

Write-Host ""
