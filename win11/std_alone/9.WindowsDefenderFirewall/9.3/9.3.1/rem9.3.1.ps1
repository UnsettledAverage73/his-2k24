# Remedi.ps1
# Description: Sets 'Windows Firewall: Public: Firewall state' to On (recommended).

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
$regValue = "EnableFirewall"
$newValue = 1  # 1 means On (recommended)

# Ensure the registry path exists
if (-not (Test-Path -Path $regPath)) {
    try {
        New-Item -Path $regPath -Force | Out-Null
        Write-Host "INFO: Created missing registry path: $regPath." -ForegroundColor Yellow
    } catch {
        Write-Host "ERROR: Failed to create registry path: $regPath. $_" -ForegroundColor Red
        exit
    }
}

# Set the registry value to enable the firewall for the Public profile
try {
    Set-ItemProperty -Path $regPath -Name $regValue -Value $newValue
    Write-Host "SUCCESS: 'Windows Firewall: Public: Firewall state' has been set to On (recommended)." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure 'Windows Firewall: Public: Firewall state'. $_" -ForegroundColor Red
}
