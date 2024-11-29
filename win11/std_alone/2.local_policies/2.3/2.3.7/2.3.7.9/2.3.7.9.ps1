# Title: Audit Script for 'Interactive logon: Smart card removal behavior'
# Description: Verifies that 'Interactive logon: Smart card removal behavior' is set to 'Lock Workstation' or higher.

Write-Host "Starting Audit: 'Interactive logon: Smart card removal behavior' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regValueName = "ScRemoveOption"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        switch ($regValue) {
            1 { Write-Host "PASS: 'Interactive logon: Smart card removal behavior' is set to 'Lock Workstation'." -ForegroundColor Green }
            2 { Write-Host "PASS: 'Interactive logon: Smart card removal behavior' is set to 'Force Logoff'." -ForegroundColor Green }
            3 { Write-Host "PASS: 'Interactive logon: Smart card removal behavior' is set to 'Disconnect if Remote Desktop session'." -ForegroundColor Green }
            default { Write-Host "FAIL: 'Interactive logon: Smart card removal behavior' is set to an invalid value ($regValue)." -ForegroundColor Red }
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

