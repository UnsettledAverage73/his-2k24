# Remedi.ps1
# Description: Enables the Windows Firewall: Domain: Firewall state by setting the registry value to 1.

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
$regValue = "EnableFirewall"
$enableValue = 1

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

# Set the registry value to enable the firewall
try {
    Set-ItemProperty -Path $regPath -Name $regValue -Value $enableValue
    Write-Host "SUCCESS: Windows Firewall: Domain: Firewall state has been set to On (recommended) (`EnableFirewall` = 1)." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to set Windows Firewall: Domain: Firewall state. $_" -ForegroundColor Red
}
