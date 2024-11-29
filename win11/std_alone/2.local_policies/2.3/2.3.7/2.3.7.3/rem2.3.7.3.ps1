# Title: Remediation Script for 'Interactive logon: Machine account lockout threshold'
# Description: Configures the machine account lockout threshold to 10 or fewer invalid logon attempts.

Write-Host "Starting Remediation: Configuring 'Interactive logon: Machine account lockout threshold' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "MaxDevicePasswordFailedAttempts"
$desiredValue = 10

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the desired value (10)
    Write-Host "Configuring registry value '$regValueName' to '$desiredValue' (10 invalid attempts)..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredValue) {
        Write-Host "SUCCESS: 'Interactive logon: Machine account lockout threshold' is now set to 10 or fewer invalid logon attempts." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Interactive logon: Machine account lockout threshold' to the desired value." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

