# Title: Audit Script for 'Domain member: Disable machine account password changes'
# Description: Verifies that the policy is set to 'Disabled' in the registry.

Write-Host "Starting Audit: 'Domain member: Disable machine account password changes' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$regValueName = "DisablePasswordChange"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -eq 0) {
            Write-Host "PASS: 'Domain member: Disable machine account password changes' is set to 'Disabled'." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Domain member: Disable machine account password changes' is NOT set to 'Disabled'. Current value: $regValue" -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

