# Title: Remediation Script for 'Accounts: Guest account status' Policy
# Description: This script disables the Guest account.

Write-Host "Starting Remediation: Configuring 'Accounts: Guest account status' policy" -ForegroundColor Yellow

# Registry path and value name
$regPath = "HKLM:\SAM\SAM\Domains\Account\Users\000001F5"
$regValueName = "F"

try {
    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        Write-Host "ERROR: Registry path $regPath does not exist. Unable to apply remediation." -ForegroundColor Red
        exit 1
    }

    # Retrieve the current registry value
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValueName -ErrorAction SilentlyContinue

    # Modify the Guest account status to 'Disabled' (set bit 1 in the value)
    $newValue = $currentValue
    $newValue[0] = $newValue[0] -bor 0x02

    # Apply the new value
    Write-Host "Applying the policy: Disabling the Guest account..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $newValue

    Write-Host "SUCCESS: 'Accounts: Guest account status' policy is now set to 'Disabled'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

