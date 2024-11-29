# Title: CIS Control 19.7.8.4 (L2) - Check 'Turn Off All Windows Spotlight Features'

Write-Host "Checking compliance for: CIS Control 19.7.8.4 (L2) - Turn Off All Windows Spotlight Features"

$registryBasePath = "HKU:\"
$regSubPath = "Software\Policies\Microsoft\Windows\CloudContent"
$regValueName = "DisableWindowsSpotlightFeatures"
$expectedValue = 1

# Get all user SIDs from the registry
$sidList = Get-ChildItem -Path $registryBasePath | Where-Object { $_.Name -match "^S-1-5-[0-9-]+$" }

if ($sidList) {
    foreach ($sid in $sidList) {
        $regPath = Join-Path -Path $sid.FullName -ChildPath $regSubPath
        if (Test-Path -Path $regPath) {
            $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
            if ($currentValue -eq $expectedValue) {
                Write-Host "Compliant for user SID $($sid.Name): 'Turn Off All Windows Spotlight Features' is set to Enabled." -ForegroundColor Green
            } else {
                Write-Host "Non-Compliant for user SID $($sid.Name): Current value is $currentValue." -ForegroundColor Red
            }
        } else {
            Write-Host "Non-Compliant for user SID $($sid.Name): Registry key not found." -ForegroundColor Red
        }
    }
} else {
    Write-Host "No user SIDs found in the registry." -ForegroundColor Yellow
}

