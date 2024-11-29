# Title: CIS Control 18.10.5.2 (L2) - Remediate 'Block Launching Universal Windows Apps with Windows Runtime API Access from Hosted Content'

Write-Host "Remediating: CIS Control 18.10.5.2 (L2) - Block Universal Windows Apps with Windows Runtime API Access from Hosted Content"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "BlockHostedAppAccessWinRT"
$expectedValue = 1

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Block Launching Universal Windows Apps with Windows Runtime API Access from Hosted Content' is now set to 'Enabled'." -ForegroundColor Green

