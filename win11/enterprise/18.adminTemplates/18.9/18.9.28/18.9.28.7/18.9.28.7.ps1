# check.ps1
# Script to check the status of "Turn on convenience PIN sign-in" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "AllowDomainPINLogon"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: The policy 'Turn on convenience PIN sign-in' is set to Disabled."
        } else {
            Write-Output "FAIL: The policy 'Turn on convenience PIN sign-in' is set to Enabled."
        }
    } else {
        Write-Output "FAIL: The policy 'Turn on convenience PIN sign-in' is not configured."
    }
} else {
    Write-Output "FAIL: The registry path for the policy does not exist."
}
