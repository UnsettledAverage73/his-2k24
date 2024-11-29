# check.ps1
# Script to verify if 'Enforce password history' is set to 24 or more

Write-Host "Checking 'Enforce password history' setting..." -ForegroundColor Cyan

# Get the current policy value
$passwordHistory = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'PasswordHistorySize'

if ($passwordHistory -ge 24) {
    Write-Host "'Enforce password history' is correctly set to $passwordHistory passwords remembered." -ForegroundColor Green
} else {
    Write-Host "'Enforce password history' is incorrectly set to $passwordHistory. It should be 24 or more." -ForegroundColor Red
}
