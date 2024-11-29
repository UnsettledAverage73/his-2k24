# check.ps1
# Script to verify if 'Minimum password age' is set to 1 or more days

Write-Host "Checking 'Minimum password age' setting..." -ForegroundColor Cyan

# Get the current policy value
$minPasswordAge = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'MinimumPasswordAge'

if ($minPasswordAge -ge 1) {
    Write-Host "'Minimum password age' is correctly set to $minPasswordAge day(s)." -ForegroundColor Green
} else {
    Write-Host "'Minimum password age' is incorrectly set to $minPasswordAge day(s). It should be 1 or more." -ForegroundColor Red
}
