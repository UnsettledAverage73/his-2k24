# remedi.ps1
# Script to set 'Account lockout duration' to 15 minutes

Write-Host "Setting 'Account lockout duration' policy to 15 minutes..." -ForegroundColor Cyan

# Path to the policy
$policyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"

# Set lockout duration to 15 minutes (Value stored as -15 in 100-nanosecond ticks)
Set-ItemProperty -Path $policyPath -Name "MaximumLockoutDuration" -Value -9000000000 -Type DWord

# Verify the change
$lockoutDuration = (Get-ItemProperty -Path $policyPath -Name "MaximumLockoutDuration" -ErrorAction SilentlyContinue).MaximumLockoutDuration
$lockoutMinutes = [math]::Round($lockoutDuration / -600000000)

if ($lockoutMinutes -eq 15) {
    Write-Host "'Account lockout duration' successfully set to $lockoutMinutes minutes." -ForegroundColor Green
} else {
    Write-Host "Failed to set 'Account lockout duration'. Current value: $lockoutMinutes minutes." -ForegroundColor Red
}
