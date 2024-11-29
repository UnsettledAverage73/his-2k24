# Title: CIS Control 18.10.8.1.1 (L1) - Remediate 'Configure Enhanced Anti-Spoofing'

Write-Host "Remediating: CIS Control 18.10.8.1.1 (L1) - Configure Enhanced Anti-Spoofing"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures"
$regValueName = "EnhancedAntiSpoofing"
$expectedValue = 1  # Value for 'Enabled'

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Configure Enhanced Anti-Spoofing' is now set to 'Enabled'." -ForegroundColor Green

