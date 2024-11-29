# remedi.ps1
# Script to set 'Account lockout threshold' policy to 5 invalid login attempts

Write-Host "Setting 'Account lockout threshold' policy to 5 invalid attempts..." -ForegroundColor Cyan

# Path to the policy
$policyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"

# Set Account Lockout Threshold to 5 (invalid logon attempts)
Set-ItemProperty -Path $policyPath -Name "AccountLockoutThreshold" -Value 5

# Verify the change
$lockoutThreshold = (Get-ItemProperty -Path $policyPath -Name "AccountLockoutThreshold" -ErrorAction SilentlyContinue).AccountLockoutThreshold

if ($lockoutThreshold -eq 5) {
    Write-Host "'Account lockout threshold' successfully set to $lockoutThreshold invalid attempts." -ForegroundColor Green
} else {
    Write-Host "Failed to set 'Account lockout threshold'. Current value: $lockoutThreshold" -ForegroundColor Red
}
