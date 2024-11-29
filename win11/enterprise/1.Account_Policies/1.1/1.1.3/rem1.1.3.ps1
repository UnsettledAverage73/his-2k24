# remedi.ps1
# Script to set 'Minimum password age' to 1 day

Write-Host "Setting 'Minimum password age' to 1 day..." -ForegroundColor Cyan

# Set the policy value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name 'MinimumPasswordAge' -Value 1

# Verify the change
$minPasswordAge = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'MinimumPasswordAge'

if ($minPasswordAge -eq 1) {
    Write-Host "'Minimum password age' successfully set to $minPasswordAge day(s)." -ForegroundColor Green
} else {
    Write-Host "Failed to set 'Minimum password age'. Current value is $minPasswordAge." -ForegroundColor Red
}
