# check.ps1
# Script to check the status of "Do not enumerate connected users on domain-joined computers" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "DontEnumerateConnectedUsers"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: The policy 'Do not enumerate connected users on domain-joined computers' is set to Enabled."
        } else {
            Write-Output "FAIL: The policy 'Do not enumerate connected users on domain-joined computers' is set to Disabled."
        }
    } else {
        Write-Output "FAIL: The policy 'Do not enumerate connected users on domain-joined computers' is not configured."
    }
} else {
    Write-Output "FAIL: The registry path for the policy does not exist."
}
