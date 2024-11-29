# Title: CIS Control 18.10.7.3 (L1) - Remediate 'Turn Off Autoplay'

Write-Host "Remediating: CIS Control 18.10.7.3 (L1) - Turn Off Autoplay"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regValueName = "NoDriveTypeAutoRun"
$expectedValue = 255  # Value for 'Enabled: All Drives'

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Turn Off Autoplay' is now set to 'Enabled: All Drives'." -ForegroundColor Green

