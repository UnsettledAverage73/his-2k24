# remedi.ps1
# Script to set 'Maximum password age' to 365 days

Write-Host "Setting 'Maximum password age' to 365 days..." -ForegroundColor Cyan

# Set the policy value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name 'MaximumPasswordAge' -Value 365

# Verify the change
$maxPasswordAge = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'MaximumPasswordAge'

if ($maxPasswordAge -eq 365) {
    Write-Host "'Maximum password age' successfully set to $maxPasswordAge days." -ForegroundColor Green
} else {
    Write-Host "Failed to set 'Maximum password age'. Current value is $maxPasswordAge." -ForegroundColor Red
}
