# Title: Remediation Script for 'Accounts: Limit local account use of blank passwords to console logon only' Policy
# Description: This script enables the policy to limit the use of blank passwords to console logon only.

Write-Host "Starting Remediation: Configuring 'Accounts: Limit local account use of blank passwords to console logon only' policy" -ForegroundColor Yellow

# Registry path and value name
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regValueName = "LimitBlankPasswordUse"
$newValue = 1

try {
    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        Write-Host "ERROR: Registry path $regPath does not exist. Unable to apply remediation." -ForegroundColor Red
        exit 1
    }

    # Apply the policy value
    Write-Host "Applying the policy: Limiting blank password use to console logon only..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $newValue

    Write-Host "SUCCESS: 'Accounts: Limit local account use of blank passwords to console logon only' policy is now set to 'Enabled'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

