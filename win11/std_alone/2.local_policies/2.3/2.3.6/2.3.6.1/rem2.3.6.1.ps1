# Title: Remediation Script for 'Domain member: Digitally encrypt or sign secure channel data (always)'
# Description: Configures the policy to 'Enabled' by setting the registry value.

Write-Host "Starting Remediation: Configuring 'Domain member: Digitally encrypt or sign secure channel data (always)' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$regValueName = "RequireSignOrSeal"
$desiredValue = 1

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value
    Write-Host "Configuring registry value '$regValueName' to '$desiredValue'..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredValue) {
        Write-Host "SUCCESS: 'Domain member: Digitally encrypt or sign secure channel data (always)' is now set to 'Enabled'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Domain member: Digitally encrypt or sign secure channel data (always)' to 'Enabled'." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

