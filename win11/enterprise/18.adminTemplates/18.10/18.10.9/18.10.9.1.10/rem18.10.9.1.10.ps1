# Title: CIS Control 18.10.9.1.10 (BL) - Remediate 'Configure use of hardware-based encryption for fixed data drives'

Write-Output "Remediating: CIS Control 18.10.9.1.10 (BL) - Configure use of hardware-based encryption for fixed data drives"

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValue = "FDVHardwareEncryption"
$desiredValue = 0

# Set the registry value
try {
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regValue -Value $desiredValue -Type DWord
    Write-Output "Remediated: 'Configure use of hardware-based encryption for fixed data drives' is now set to 'Disabled'."
} catch {
    Write-Output "Error: Failed to set the registry value. Please check permissions and try again."
}

