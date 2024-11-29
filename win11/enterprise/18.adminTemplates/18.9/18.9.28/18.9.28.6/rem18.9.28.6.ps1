# remedi.ps1
# Script to enable "Turn off picture password sign-in" policy.

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regValue = "BlockDomainPicturePassword"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to enable the policy
Set-ItemProperty -Path $regPath -Name $regValue -Value 1 -Type DWord

# Verify the remediation
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 1) {
    Write-Output "The policy 'Turn off picture password sign-in' has been successfully set to Enabled."
} else {
    Write-Output "ERROR: Failed to configure the policy 'Turn off picture password sign-in'."
}
