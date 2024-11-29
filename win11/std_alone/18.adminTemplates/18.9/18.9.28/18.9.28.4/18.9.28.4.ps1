# check.ps1
# Script to check the status of "Enumerate local users on domain-joined computers" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "EnumerateLocalUsers"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: The policy 'Enumerate local users on domain-joined computers' is set to Disabled."
        } else {
            Write-Output "FAIL: The policy 'Enumerate local users on domain-joined computers' is set to Enabled."
        }
    } else {
        Write-Output "FAIL: The policy 'Enumerate local users on domain-joined computers' is not configured."
    }
} else {
    Write-Output "FAIL: The registry path for the policy does not exist."
}
