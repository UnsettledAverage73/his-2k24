# check.ps1
# Script to verify if 'Account lockout duration' is set to 15 or more minutes

Write-Host "Checking 'Account lockout duration' policy setting..." -ForegroundColor Cyan

# Path to the policy
$policyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$lockoutDuration = (Get-ItemProperty -Path $policyPath -Name "MaximumLockoutDuration" -ErrorAction SilentlyContinue).MaximumLockoutDuration

# Convert to minutes (Value is stored as ticks)
if ($lockoutDuration) {
    $lockoutMinutes = [math]::Round($lockoutDuration / -600000000)
    if ($lockoutMinutes -ge 15) {
        Write-Host "'Account lockout duration' is correctly set to $lockoutMinutes minutes." -ForegroundColor Green
    } else {
        Write-Host "'Account lockout duration' is set to $lockoutMinutes minutes. It should be 15 or more minutes." -ForegroundColor Red
    }
} else {
    Write-Host "'Account lockout duration' is not configured." -ForegroundColor Red
}
