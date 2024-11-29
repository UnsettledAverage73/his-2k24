# Title: Remediation Script for 'Interactive logon: Do not require CTRL+ALT+DEL'
# Description: Configures the policy to 'Disabled' by setting the registry value to 0.

Write-Host "Starting Remediation: Configuring 'Interactive logon: Do not require CTRL+ALT+DEL' policy" -ForegroundColor Yellow

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "DisableCAD"
$desiredValue = 0

try {
    # Check if the registry path exists, and create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path not found. Creating $regPath..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 0 (disabled)
    Write-Host "Configuring registry value '$regValueName' to '$desiredValue' (Disabled)..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord

    # Verify the change
    $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
    if ($regValue -eq $desiredValue) {
        Write-Host "SUCCESS: 'Interactive logon: Do not require CTRL+ALT+DEL' is now Disabled." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Unable to set 'Interactive logon: Do not require CTRL+ALT+DEL' to Disabled." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred during remediation. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

