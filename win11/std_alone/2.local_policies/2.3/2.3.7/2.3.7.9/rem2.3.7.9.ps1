# Title: Remediation Script for 'Interactive logon: Smart card removal behavior'
# Description: Configures 'Interactive logon: Smart card removal behavior' to 'Lock Workstation' or higher.

Write-Host "Starting Remediation: Configuring 'Interactive logon: Smart card removal behavior' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regValueName = "ScRemoveOption"
$desiredValue = 1  # Set to 1 for 'Lock Workstation'

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the desired value (1 for 'Lock Workstation')
    Write-Host "Configuring registry value '$regValueName' to Lock Workstation (1)..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredValue) {
        Write-Host "SUCCESS: 'Interactive logon: Smart card removal behavior' is now set to 'Lock Workstation'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Interactive logon: Smart card removal behavior' to the desired value." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

