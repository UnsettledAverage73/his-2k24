# Title: Audit Script for 'Interactive logon: Machine inactivity limit'
# Description: Verifies that the machine inactivity limit is set to 900 or fewer seconds, but not 0.

Write-Host "Starting Audit: 'Interactive logon: Machine inactivity limit' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "InactivityTimeoutSecs"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -gt 0 -and $regValue -le 900) {
            Write-Host "PASS: 'Interactive logon: Machine inactivity limit' is set to $regValue seconds, within the recommended range." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Interactive logon: Machine inactivity limit' is NOT set to a value between 1 and 900. Current value: $regValue" -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

