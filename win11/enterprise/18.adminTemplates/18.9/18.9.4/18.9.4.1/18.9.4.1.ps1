# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters"
$valueName = "AllowEncryptionOracle"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 0) {
        Write-Output "'Encryption Oracle Remediation' is correctly set to 'Enabled: Force Updated Clients'."
    } elseif ($value.$valueName -eq 1) {
        Write-Output "'Encryption Oracle Remediation' is set to 'Enabled: Mitigated', not the recommended 'Force Updated Clients'."
    } elseif ($value.$valueName -eq 2) {
        Write-Output "'Encryption Oracle Remediation' is set to 'Enabled: Vulnerable', which is not secure."
    } else {
        Write-Output "'Encryption Oracle Remediation' is not configured as recommended. Current Value: $($value.$valueName)"
    }
} else {
    Write-Output "'Encryption Oracle Remediation' is not configured. Registry key does not exist."
}
