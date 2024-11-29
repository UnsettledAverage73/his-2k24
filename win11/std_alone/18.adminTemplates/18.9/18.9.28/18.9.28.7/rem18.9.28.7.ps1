# remedi.ps1
# Script to disable "Turn on convenience PIN sign-in" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "AllowDomainPINLogon"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to disable the policy
Set-ItemProperty -Path $regPath -Name $regValue -Value 0 -Type DWord

# Verify the remediation
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 0) {
    Write-Output "The policy 'Turn on convenience PIN sign-in' has been successfully set to Disabled."
} else {
    Write-Output "ERROR: Failed to configure the policy 'Turn on convenience PIN sign-in'."
}
