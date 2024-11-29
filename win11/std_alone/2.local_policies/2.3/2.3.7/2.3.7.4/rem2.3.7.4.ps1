# Title: Remediation Script for 'Interactive logon: Machine inactivity limit'
# Description: Configures the machine inactivity limit to 900 or fewer seconds, but not 0.

Write-Host "Starting Remediation: Configuring 'Interactive logon: Machine inactivity limit' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "InactivityTimeoutSecs"
$desiredValue = 900

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the desired value (900 seconds)
    Write-Host "Configuring registry value '$regValueName' to '$desiredValue' (900 seconds of inactivity)..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredValue) {
        Write-Host "SUCCESS: 'Interactive logon: Machine inactivity limit' is now set to 900 or fewer seconds." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Interactive logon: Machine inactivity limit' to the desired value." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

