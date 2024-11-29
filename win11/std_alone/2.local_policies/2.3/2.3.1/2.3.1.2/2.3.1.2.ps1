# Title: Audit Script for 'Accounts: Guest account status' Policy
# Description: This script checks if the 'Accounts: Guest account status' policy is set to 'Disabled'.

Write-Host "Starting Audit: 'Accounts: Guest account status' policy" -ForegroundColor Green

# Registry path and value name
$regPath = "HKLM:\SAM\SAM\Domains\Account\Users\000001F5"
$regValueName = "F"

# Retrieve and check the current Guest account status
try {
    if (Test-Path $regPath) {
        $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValueName -ErrorAction SilentlyContinue
        if (($currentValue[0] -band 0x02) -eq 0x02) {
            Write-Host "PASS: 'Accounts: Guest account status' is set to 'Disabled'." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Accounts: Guest account status' is not set to 'Disabled'. Please remediate." -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry path $regPath does not exist." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: Failed to read the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

