# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
$valueName = "NoCloudApplicationNotification"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Turn off notifications network usage' is correctly set to 'Enabled'."
    } else {
        Write-Output "'Turn off notifications network usage' is not configured as recommended. Current Value: $($value.$valueName)"
    }
} else {
    Write-Output "'Turn off notifications network usage' is not configured. Registry key does not exist."
}
