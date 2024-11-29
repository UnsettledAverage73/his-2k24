# Title: CIS Control 19.7.44.2.1 (L2) - Remediate 'Prevent Codec Download'

Write-Host "Remediating: CIS Control 19.7.44.2.1 (L2) - Prevent Codec Download"

$registryBasePath = "HKU:\"
$regSubPath = "Software\Policies\Microsoft\WindowsMediaPlayer"
$regValueName = "PreventCodecDownload"
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
        Write-Host "Remediated for user SID $($sid.Name): 'Prevent Codec Download' is now Enabled." -ForegroundColor Green
    }
} else {
    Write-Host "No user SIDs found in the registry." -ForegroundColor Yellow
}

