# Title: Audit Script for 'Accounts: Limit local account use of blank passwords to console logon only' Policy
# Description: This script checks if the policy is set to 'Enabled'.

Write-Host "Starting Audit: 'Accounts: Limit local account use of blank passwords to console logon only' policy" -ForegroundColor Green

# Registry path and value name
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regValueName = "LimitBlankPasswordUse"

# Retrieve and check the current policy value
try {
    if (Test-Path $regPath) {
        $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValueName -ErrorAction SilentlyContinue
        if ($currentValue -eq 1) {
            Write-Host "PASS: 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Accounts: Limit local account use of blank passwords to console logon only' is not set to 'Enabled'. Please remediate." -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry path $regPath does not exist." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: Failed to read the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

