# Title: Remediation Script for 'Interactive logon: Number of previous logons to cache (in case domain controller is not available)'
# Description: Configures the 'Interactive logon: Number of previous logons to cache' to 4 or fewer logons.

Write-Host "Starting Remediation: Configuring 'Interactive logon: Number of previous logons to cache' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regValueName = "CachedLogonsCount"
$desiredValue = 4

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the desired number of cached logons
    Write-Host "Configuring registry value '$regValueName' to $desiredValue..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredValue) {
        Write-Host "SUCCESS: 'Interactive logon: Number of previous logons to cache' is now set to $desiredValue logons." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Interactive logon: Number of previous logons to cache' to the desired value." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

