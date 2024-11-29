# Title: Remediation Script for 'Interactive logon: Prompt user to change password before expiration'
# Description: Configures the 'Interactive logon: Prompt user to change password before expiration' to a value between 5 and 14 days.

Write-Host "Starting Remediation: Configuring 'Interactive logon: Prompt user to change password before expiration' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regValueName = "PasswordExpiryWarning"
$desiredValue = 7  # Set to a value between 5 and 14 (e.g., 7 days)

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the desired number of days
    Write-Host "Configuring registry value '$regValueName' to $desiredValue days..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredValue) {
        Write-Host "SUCCESS: 'Interactive logon: Prompt user to change password before expiration' is now set to $desiredValue days." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Interactive logon: Prompt user to change password before expiration' to the desired value." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

