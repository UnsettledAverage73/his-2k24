# Title: Remediation Script for 'Accounts: Block Microsoft accounts' Policy
# Description: This script sets the 'Accounts: Block Microsoft accounts' policy to 'Users can't add or log on with Microsoft accounts'.

Write-Host "Starting Remediation: Configuring 'Accounts: Block Microsoft accounts' policy" -ForegroundColor Yellow

# Registry path and value name
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "NoConnectedUser"
$desiredValue = 3  # 'Users can't add or log on with Microsoft accounts'

try {
    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path $regPath does not exist. Creating it..." -ForegroundColor Cyan
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the desired value in the registry
    Write-Host "Applying the policy: Setting $regValueName to $desiredValue..." -ForegroundColor Cyan
    Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue

    Write-Host "SUCCESS: 'Accounts: Block Microsoft accounts' policy is now set to 'Users can't add or log on with Microsoft accounts'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

