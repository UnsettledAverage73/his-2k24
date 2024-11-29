# Title: CIS Control 19.6.6.1.1 (L2) - Remediate 'Turn off Help Experience Improvement Program'

Write-Host "Remediating: CIS Control 19.6.6.1.1 (L2) - Turn off Help Experience Improvement Program"

$registryBasePath = "HKU:\"
$regSubPath = "Software\Policies\Microsoft\Assistance\Client\1.0"
$regValueName = "NoImplicitFeedback"
$expectedValue = 1

# Get all user SIDs from the registry
$sidList = Get-ChildItem -Path $registryBasePath | Where-Object { $_.Name -match "^S-1-5-[0-9-]+$" }

if ($sidList) {
    foreach ($sid in $sidList) {
        $regPath = Join-Path -Path $sid.FullName -ChildPath $regSubPath
        if (-not (Test-Path -Path $regPath)) {
            Write-Host "Creating registry path for user SID $($sid.Name)..." -ForegroundColor Yellow
            New-Item -Path $regPath -Force | Out-Null
        }

        Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
        Write-Host "Remediated for user SID $($sid.Name): 'Turn off Help Experience Improvement Program' is now set to Enabled." -ForegroundColor Green
    }
} else {
    Write-Host "No user SIDs found in the registry." -ForegroundColor Yellow
}

