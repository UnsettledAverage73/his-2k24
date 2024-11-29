# Remedi.ps1
# Description: Disables the Computer Browser service or ensures it is not installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Browser"
$regValue = "Start"
$disableValue = 4

# Disable the Computer Browser service
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Computer Browser service has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable the Computer Browser service. $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Computer Browser service is not installed." -ForegroundColor Green
}

# Optional: Check and remove SMBv1 (Windows 8.1/10+)
if (Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq "SMB1Protocol" -and $_.State -eq "Enabled" }) {
    try {
        Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart -ErrorAction Stop
        Write-Host "SUCCESS: SMB1Protocol has been disabled." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable SMB1Protocol. $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: SMB1Protocol is already disabled or not installed." -ForegroundColor Green
}
