# Remedi.ps1
# Description: Disables the Special Administration Console Helper (sacsvr) service by setting the registry value to 4 or ensures the service is not installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\sacsvr"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Special Administration Console Helper (sacsvr) service has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Special Administration Console Helper (sacsvr) service. $_" -ForegroundColor Red
    }
} else {
    # Check for the optional feature and remove it if installed
    try {
        Write-Host "INFO: Checking for Windows Emergency Management Services feature..." -ForegroundColor Yellow
        $featureName = "EMSSupport"
        $installedFeature = Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq $featureName -and $_.State -eq "Enabled" }

        if ($installedFeature) {
            Write-Host "INFO: Found the feature. Attempting to remove it..." -ForegroundColor Yellow
            Disable-WindowsOptionalFeature -Online -FeatureName $featureName -Remove -NoRestart
            Write-Host "SUCCESS: Windows Emergency Management Services feature has been removed." -ForegroundColor Green
        } else {
            Write-Host "INFO: Special Administration Console Helper (sacsvr) service is not installed. No action required." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "ERROR: Failed to remove Windows Emergency Management Services feature. $_" -ForegroundColor Red
    }
}
