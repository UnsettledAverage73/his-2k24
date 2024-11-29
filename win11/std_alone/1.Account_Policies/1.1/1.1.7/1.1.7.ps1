# check.ps1
# Script to verify if 'Store passwords using reversible encryption' is disabled

Write-Host "Checking 'Store passwords using reversible encryption' setting..." -ForegroundColor Cyan

# Get the current policy value
$storePasswords = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").'StoreClearTextPasswords'

if ($storePasswords -eq 0 -or $storePasswords -eq $null) {
    Write-Host "'Store passwords using reversible encryption' is correctly set to Disabled." -ForegroundColor Green
} else {
    Write-Host "'Store passwords using reversible encryption' is NOT disabled. Current value: $storePasswords (should be 0)." -ForegroundColor Red
}
