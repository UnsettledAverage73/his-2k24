# check.ps1
# Script to verify if 'Maximum password age' is set to 365 or fewer days but not 0

Write-Host "Checking 'Maximum password age' setting..." -ForegroundColor Cyan

# Get the current policy value
$maxPasswordAge = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'MaximumPasswordAge'

if ($maxPasswordAge -le 365 -and $maxPasswordAge -ne 0) {
    Write-Host "'Maximum password age' is correctly set to $maxPasswordAge days." -ForegroundColor Green
} else {
    Write-Host "'Maximum password age' is incorrectly set to $maxPasswordAge. It should be 365 or fewer days and not 0." -ForegroundColor Red
}
