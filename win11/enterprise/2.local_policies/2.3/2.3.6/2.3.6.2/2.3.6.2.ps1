# Title: Audit Script for 'Domain member: Digitally encrypt secure channel data (when possible)'
# Description: Verifies that the policy is set to 'Enabled' in the registry.

Write-Host "Starting Audit: 'Domain member: Digitally encrypt secure channel data (when possible)' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$regValueName = "SealSecureChannel"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -eq 1) {
            Write-Host "PASS: 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Domain member: Digitally encrypt secure channel data (when possible)' is NOT set to 'Enabled'. Current value: $regValue" -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

