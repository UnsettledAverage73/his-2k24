# check.ps1
# Script to verify if 'Relax minimum password length limits' is enabled

Write-Host "Checking 'Relax minimum password length limits' setting..." -ForegroundColor Cyan

# Get the current policy value
$relaxPwdLength = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\SAM").'RelaxMinimumPasswordLengthLimits'

if ($relaxPwdLength -eq 1) {
    Write-Host "'Relax minimum password length limits' is correctly set to Enabled." -ForegroundColor Green
} else {
    Write-Host "'Relax minimum password length limits' is NOT enabled. Current value: $relaxPwdLength (should be 1)." -ForegroundColor Red
}
