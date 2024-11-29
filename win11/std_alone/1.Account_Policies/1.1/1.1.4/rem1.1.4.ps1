# remedi.ps1
# Script to set 'Minimum password length' to 14 characters

Write-Host "Setting 'Minimum password length' to 14 characters..." -ForegroundColor Cyan

# Set the policy value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name 'MinimumPasswordLength' -Value 14

# Verify the change
$minPasswordLength = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'MinimumPasswordLength'

if ($minPasswordLength -eq 14) {
    Write-Host "'Minimum password length' successfully set to $minPasswordLength character(s)." -ForegroundColor Green
} else {
    Write-Host "Failed to set 'Minimum password length'. Current value is $minPasswordLength." -ForegroundColor Red
}
