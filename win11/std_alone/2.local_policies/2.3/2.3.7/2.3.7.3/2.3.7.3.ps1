# Title: Audit Script for 'Interactive logon: Machine account lockout threshold'
# Description: Verifies that the machine account lockout threshold is set to 10 or fewer invalid logon attempts.

Write-Host "Starting Audit: 'Interactive logon: Machine account lockout threshold' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "MaxDevicePasswordFailedAttempts"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -gt 0 -and $regValue -le 10) {
            Write-Host "PASS: 'Interactive logon: Machine account lockout threshold' is set to $regValue, within the recommended range." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Interactive logon: Machine account lockout threshold' is NOT set to a value between 1 and 10. Current value: $regValue" -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

