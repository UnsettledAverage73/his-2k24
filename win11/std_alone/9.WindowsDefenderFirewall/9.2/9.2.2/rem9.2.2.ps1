# Remedi.ps1
# Description: Sets 'Windows Firewall: Private: Inbound connections' to 'Block (default)'.

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
$regValue = "DefaultInboundAction"
$newValue = 1 # 1 = Block

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

# Set the registry value to block inbound connections for the Private profile
try {
    Set-ItemProperty -Path $regPath -Name $regValue -Value $newValue
    Write-Host "SUCCESS: 'Windows Firewall: Private: Inbound connections' has been set to 'Block (default)'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure 'Windows Firewall: Private: Inbound connections'. $_" -ForegroundColor Red
}
