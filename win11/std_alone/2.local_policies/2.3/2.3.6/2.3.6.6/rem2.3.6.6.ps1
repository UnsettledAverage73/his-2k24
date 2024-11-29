# Title: Remediation Script for 'Domain member: Require strong (Windows 2000 or later) session key'
# Description: Configures the policy to 'Enabled' by setting the registry value to 1.

Write-Host "Starting Remediation: Configuring 'Domain member: Require strong (Windows 2000 or later) session key' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$regValueName = "RequireStrongKey"
$desiredValue = 1

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 1 (enabled)
    Write-Host "Configuring registry value '$regValueName' to '$desiredValue' (Enabled)..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredValue) {
        Write-Host "SUCCESS: 'Domain member: Require strong session key' is now enabled." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Domain member: Require strong session key' to enabled." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

