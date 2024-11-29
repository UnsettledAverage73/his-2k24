# check.ps1
# Script to verify if 'Password must meet complexity requirements' is enabled

Write-Host "Checking 'Password must meet complexity requirements' setting..." -ForegroundColor Cyan

# Get the current policy value
$complexityRequirement = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'PasswordComplexity'

if ($complexityRequirement -eq 1) {
    Write-Host "'Password must meet complexity requirements' is correctly set to Enabled." -ForegroundColor Green
} else {
    Write-Host "'Password must meet complexity requirements' is NOT enabled. Current value: $complexityRequirement (should be 1)." -ForegroundColor Red
}
