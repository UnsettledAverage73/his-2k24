# Title: CIS Control 18.10.9.1.3 (BL) - Remediate 'Allow Data Recovery Agent' for BitLocker-protected fixed drives

Write-Host "Remediating: CIS Control 18.10.9.1.3 (BL) - Allow Data Recovery Agent"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVManageDRA"
$desiredValue = 1

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord
Write-Host "Remediated: 'Allow data recovery agent' is now set to 'Enabled: True'." -ForegroundColor Green

