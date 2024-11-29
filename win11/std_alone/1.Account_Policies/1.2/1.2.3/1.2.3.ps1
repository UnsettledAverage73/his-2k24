# check.ps1
# Script to check 'Allow Administrator account lockout' policy

Write-Host "Checking 'Allow Administrator account lockout' policy..." -ForegroundColor Cyan

# Registry path and value for the policy
$policyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$policyName = "AdminAccountLockout"

# Check the policy status
try {
    $policyValue = (Get-ItemProperty -Path $policyPath -Name $policyName -ErrorAction Stop).$policyName

    if ($policyValue -eq 1) {
        Write-Host "'Allow Administrator account lockout' is correctly set to Enabled." -ForegroundColor Green
    } else {
        Write-Host "'Allow Administrator account lockout' is NOT set to Enabled. Current value: $policyValue" -ForegroundColor Red
    }
} catch {
    Write-Host "The policy 'Allow Administrator account lockout' is not configured." -ForegroundColor Red
}
