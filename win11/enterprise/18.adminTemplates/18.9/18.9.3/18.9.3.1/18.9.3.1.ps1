# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "ProcessCreationIncludeCmdLine_Enabled"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Include command line in process creation events' is correctly set to 'Enabled'."
    } else {
        Write-Output "'Include command line in process creation events' is not configured as recommended. Current Value: $($value.$valueName)"
    }
} else {
    Write-Output "'Include command line in process creation events' is not configured. Registry key does not exist."
}
