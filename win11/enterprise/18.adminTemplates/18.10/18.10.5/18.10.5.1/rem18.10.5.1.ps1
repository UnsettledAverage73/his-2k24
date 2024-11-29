# Title: CIS Control 18.10.5.1 (L1) - Remediate 'Allow Microsoft Accounts to be Optional'

Write-Host "Remediating: CIS Control 18.10.5.1 (L1) - Allow Microsoft Accounts to be Optional"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "MSAOptional"
$expectedValue = 1

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Allow Microsoft Accounts to be Optional' is now set to 'Enabled'." -ForegroundColor Green

