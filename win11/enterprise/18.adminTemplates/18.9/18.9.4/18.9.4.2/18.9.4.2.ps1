# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"
$valueName = "AllowProtectedCreds"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Remote host allows delegation of non-exportable credentials' is correctly set to 'Enabled'."
    } elseif ($value.$valueName -eq 0) {
        Write-Output "'Remote host allows delegation of non-exportable credentials' is set to 'Disabled', which is not recommended."
    } else {
        Write-Output "'Remote host allows delegation of non-exportable credentials' is not configured as recommended. Current Value: $($value.$valueName)"
    }
} else {
    Write-Output "'Remote host allows delegation of non-exportable credentials' is not configured. Registry key does not exist."
}
