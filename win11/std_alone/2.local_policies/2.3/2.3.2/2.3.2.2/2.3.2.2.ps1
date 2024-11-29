# Title: Audit Script for 'Audit: Shut down system immediately if unable to log security audits'
# Description: Verifies that the policy is set to 'Disabled' in the registry.

Write-Host "Starting Audit: 'Audit: Shut down system immediately if unable to log security audits' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regValueName = "CrashOnAuditFail"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -eq 0) {
            Write-Host "PASS: 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Audit: Shut down system immediately if unable to log security audits' is NOT set to 'Disabled'. Current value: $regValue" -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

