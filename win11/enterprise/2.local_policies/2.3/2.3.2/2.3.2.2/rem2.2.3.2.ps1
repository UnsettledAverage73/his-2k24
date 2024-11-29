# Title: Remediation Script for 'Audit: Shut down system immediately if unable to log security audits'
# Description: Configures the policy to 'Disabled' by setting the registry value.

Write-Host "Starting Remediation: Configuring 'Audit: Shut down system immediately if unable to log security audits' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regValueName = "CrashOnAuditFail"
$desiredValue = 0

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
        Write-Host "SUCCESS: 'Audit: Shut down system immediately if unable to log security audits' is now set to 'Disabled'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Audit: Shut down system immediately if unable to log security audits' to 'Disabled'." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

