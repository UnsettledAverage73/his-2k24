# Title: CIS Control 19.5.1.1 (L1) - Remediate 'Turn off toast notifications on the lock screen'

Write-Host "Remediating: CIS Control 19.5.1.1 (L1) - Turn off toast notifications on the lock screen"

$registryBasePath = "HKU:\"
$regSubPath = "Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
$regValueName = "NoToastApplicationNotificationOnLockScreen"
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
        Write-Host "Remediated for user SID $($sid.Name): 'Turn off toast notifications on the lock screen' is now set to Enabled." -ForegroundColor Green
    }
} else {
    Write-Host "No user SIDs found in the registry." -ForegroundColor Yellow
}

