# remedi.ps1
# Script to set 'Allow Administrator account lockout' policy to Enabled

Write-Host "Enabling 'Allow Administrator account lockout' policy..." -ForegroundColor Cyan

# Registry path and value for the policy
$policyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$policyName = "AdminAccountLockout"

# Ensure the registry key exists and set the value
try {
    New-Item -Path $policyPath -Force | Out-Null
    Set-ItemProperty -Path $policyPath -Name $policyName -Value 1

    # Verify the change
    $policyValue = (Get-ItemProperty -Path $policyPath -Name $policyName -ErrorAction Stop).$policyName
    if ($policyValue -eq 1) {
        Write-Host "'Allow Administrator account lockout' has been successfully set to Enabled." -ForegroundColor Green
    } else {
        Write-Host "Failed to set 'Allow Administrator account lockout'. Current value: $policyValue" -ForegroundColor Red
    }
} catch {
    Write-Host "Error occurred while setting 'Allow Administrator account lockout': $_" -ForegroundColor Red
}
