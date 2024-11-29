# Title: CIS Control 18.5.10 (L1) - Ensure 'ScreenSaverGracePeriod' Is Set to '5 Seconds or Fewer'

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regValueName = "ScreenSaverGracePeriod"
$expectedValue = 5

Write-Host "Checking compliance for: CIS Control 18.5.10 (L1) - ScreenSaverGracePeriod"

# Check if the registry key exists
if (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName).$regValueName
    if ($currentValue -le $expectedValue) {
        Write-Host "Status: Compliant (ScreenSaverGracePeriod is set to $currentValue seconds)." -ForegroundColor Green
    } else {
        Write-Host "Status: Non-Compliant (Current value: $currentValue seconds)." -ForegroundColor Red
    }
} else {
    Write-Host "Status: Non-Compliant (ScreenSaverGracePeriod registry key not found)." -ForegroundColor Red
}

