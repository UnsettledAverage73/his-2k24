# Title: CIS Control 18.10.7.1 (L1) - Remediate 'Disallow Autoplay for Non-Volume Devices'

Write-Host "Remediating: CIS Control 18.10.7.1 (L1) - Disallow Autoplay for Non-Volume Devices"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
$regValueName = "NoAutoplayfornonVolume"
$expectedValue = 1

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Disallow Autoplay for Non-Volume Devices' is now set to 'Enabled'." -ForegroundColor Green

