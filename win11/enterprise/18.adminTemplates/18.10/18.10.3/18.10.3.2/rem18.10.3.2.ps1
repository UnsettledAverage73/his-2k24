# Title: CIS Control 18.10.3.2 (L1) - Remediate 'Prevent Non-Admin Users from Installing Packaged Windows Apps'

Write-Host "Remediating: CIS Control 18.10.3.2 (L1) - Prevent Non-Admin Users from Installing Packaged Windows Apps"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx"
$regValueName = "BlockNonAdminUserInstall"
$expectedValue = 1

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Prevent Non-Admin Users from Installing Packaged Windows Apps' is now Enabled." -ForegroundColor Green

