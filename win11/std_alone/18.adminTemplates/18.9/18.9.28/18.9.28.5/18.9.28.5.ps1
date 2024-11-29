# check.ps1
# Script to check the status of "Turn off app notifications on the lock screen" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "DisableLockScreenAppNotifications"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: The policy 'Turn off app notifications on the lock screen' is set to Enabled."
        } else {
            Write-Output "FAIL: The policy 'Turn off app notifications on the lock screen' is set to Disabled."
        }
    } else {
        Write-Output "FAIL: The policy 'Turn off app notifications on the lock screen' is not configured."
    }
} else {
    Write-Output "FAIL: The registry path for the policy does not exist."
}
