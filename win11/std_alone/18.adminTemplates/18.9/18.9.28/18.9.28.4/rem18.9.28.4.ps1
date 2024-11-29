# remedi.ps1
# Script to disable "Enumerate local users on domain-joined computers" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "EnumerateLocalUsers"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to disable the policy
Set-ItemProperty -Path $regPath -Name $regValue -Value 0 -Type DWord

# Verify the remediation
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 0) {
    Write-Output "The policy 'Enumerate local users on domain-joined computers' has been successfully set to Disabled."
} else {
    Write-Output "ERROR: Failed to configure the policy 'Enumerate local users on domain-joined computers'."
}
