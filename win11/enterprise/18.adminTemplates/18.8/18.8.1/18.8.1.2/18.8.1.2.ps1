# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
$valueName = "HideRecommendedPersonalizedSites"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Remove Personalized Website Recommendations' is correctly set to 'Enabled'."
    } else {
        Write-Output "'Remove Personalized Website Recommendations' is not configured as recommended. Current Value: $($value.$valueName)"
    }
} else {
    Write-Output "'Remove Personalized Website Recommendations' is not configured. Registry key does not exist."
}
