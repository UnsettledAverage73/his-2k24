# check.ps1
# Script to check the status of "Turn off picture password sign-in" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "BlockDomainPicturePassword"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: The policy 'Turn off picture password sign-in' is set to Enabled."
        } else {
            Write-Output "FAIL: The policy 'Turn off picture password sign-in' is set to Disabled."
        }
    } else {
        Write-Output "FAIL: The policy 'Turn off picture password sign-in' is not configured."
    }
} else {
    Write-Output "FAIL: The registry path for the policy does not exist."
}
