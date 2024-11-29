# remedi.ps1
# Script to enable 'Password must meet complexity requirements'

Write-Host "Enabling 'Password must meet complexity requirements'..." -ForegroundColor Cyan

# Set the policy value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name 'PasswordComplexity' -Value 1

# Verify the change
$complexityRequirement = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'PasswordComplexity'

if ($complexityRequirement -eq 1) {
    Write-Host "'Password must meet complexity requirements' successfully enabled." -ForegroundColor Green
} else {
    Write-Host "Failed to enable 'Password must meet complexity requirements'. Current value: $complexityRequirement." -ForegroundColor Red
}
