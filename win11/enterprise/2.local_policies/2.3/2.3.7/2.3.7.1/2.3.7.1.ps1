# Title: Audit Script for 'Interactive logon: Do not require CTRL+ALT+DEL'
# Description: Verifies that the policy is set to 'Disabled' in the registry.

Write-Host "Starting Audit: 'Interactive logon: Do not require CTRL+ALT+DEL' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "DisableCAD"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -eq 0) {
            Write-Host "PASS: 'Interactive logon: Do not require CTRL+ALT+DEL' is Disabled." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Interactive logon: Do not require CTRL+ALT+DEL' is NOT Disabled. Current value: $regValue" -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

