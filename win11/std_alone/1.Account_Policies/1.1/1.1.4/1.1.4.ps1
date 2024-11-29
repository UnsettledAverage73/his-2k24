# check.ps1
# Script to verify if 'Minimum password length' is set to 14 or more characters

Write-Host "Checking 'Minimum password length' setting..." -ForegroundColor Cyan

# Get the current policy value
$minPasswordLength = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'MinimumPasswordLength'

if ($minPasswordLength -ge 14) {
    Write-Host "'Minimum password length' is correctly set to $minPasswordLength character(s)." -ForegroundColor Green
} else {
    Write-Host "'Minimum password length' is incorrectly set to $minPasswordLength character(s). It should be 14 or more." -ForegroundColor Red
}
