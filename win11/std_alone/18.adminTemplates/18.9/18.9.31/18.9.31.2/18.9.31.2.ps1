# check.ps1
# Script to check the status of "Allow Clipboard synchronization across devices" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "AllowCrossDeviceClipboard"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: The policy 'Allow Clipboard synchronization across devices' is set to Disabled."
        } else {
            Write-Output "FAIL: The policy 'Allow Clipboard synchronization across devices' is set to Enabled."
        }
    } else {
        Write-Output "FAIL: The policy 'Allow Clipboard synchronization across devices' is not configured."
    }
} else {
    Write-Output "FAIL: The registry path for the policy does not exist."
}
