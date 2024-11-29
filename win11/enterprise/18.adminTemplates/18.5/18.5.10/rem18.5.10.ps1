# Title: CIS Control 18.5.10 (L1) - Ensure 'ScreenSaverGracePeriod' Is Set to '5 Seconds or Fewer'

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regValueName = "ScreenSaverGracePeriod"
$expectedValue = 5

Write-Host "Remediating: CIS Control 18.5.10 (L1) - ScreenSaverGracePeriod"

# Check if the registry key exists, and set it if needed
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path not found. Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediation completed. ScreenSaverGracePeriod is now set to $expectedValue seconds or fewer." -ForegroundColor Green

