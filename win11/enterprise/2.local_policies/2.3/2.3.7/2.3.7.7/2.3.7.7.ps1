# Title: Audit Script for 'Interactive logon: Number of previous logons to cache (in case domain controller is not available)'
# Description: Verifies that the 'Interactive logon: Number of previous logons to cache' is set to 4 or fewer logons.

Write-Host "Starting Audit: 'Interactive logon: Number of previous logons to cache' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regValueName = "CachedLogonsCount"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -le 4) {
            Write-Host "PASS: 'Interactive logon: Number of previous logons to cache' is set to $regValue logons." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Interactive logon: Number of previous logons to cache' is set to $regValue logons, which is more than the recommended 4." -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

