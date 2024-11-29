# Title: Remediation Script for 'Interactive logon: Message text for users attempting to log on'
# Description: Configures the 'Interactive logon: Message text for users attempting to log on' to a specified message.

Write-Host "Starting Remediation: Configuring 'Interactive logon: Message text for users attempting to log on' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "LegalNoticeText"
$desiredMessage = "WARNING: This system is for authorized use only. Unauthorized access will be monitored and may result in disciplinary action."

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the desired message
    Write-Host "Configuring registry value '$regValueName' with the desired message..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredMessage -Type String

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredMessage) {
        Write-Host "SUCCESS: 'Interactive logon: Message text for users attempting to log on' is now configured." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Interactive logon: Message text for users attempting to log on' to the desired value." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

