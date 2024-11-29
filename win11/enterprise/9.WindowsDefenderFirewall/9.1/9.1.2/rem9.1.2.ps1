# Remedi.ps1
# Description: Configures 'Windows Firewall: Domain: Inbound Connections' to Block (default).

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
$regValue = "DefaultInboundAction"
$blockValue = 1  # 1 = Block (default)

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

# Set the registry value to Block
try {
    Set-ItemProperty -Path $regPath -Name $regValue -Value $blockValue
    Write-Host "SUCCESS: 'Windows Firewall: Domain: Inbound Connections' has been set to Block (default)." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure 'Windows Firewall: Domain: Inbound Connections'. $_" -ForegroundColor Red
}
