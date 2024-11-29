# Title: CIS Control 19.7.42.1 (L1) - Remediate 'Always install with elevated privileges'

Write-Host "Remediating: CIS Control 19.7.42.1 (L1) - Always install with elevated privileges"

$registryBasePath = "HKU:\"
$regSubPath = "Software\Policies\Microsoft\Windows\Installer"
$regValueName = "AlwaysInstallElevated"
$expectedValue = 0

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
        Write-Host "Remediated for user SID $($sid.Name): 'Always install with elevated privileges' is now Disabled." -ForegroundColor Green
    }
} else {
    Write-Host "No user SIDs found in the registry." -ForegroundColor Yellow
}

