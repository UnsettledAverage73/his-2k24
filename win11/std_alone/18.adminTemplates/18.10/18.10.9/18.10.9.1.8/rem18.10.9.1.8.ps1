# Title: CIS Control 18.10.9.1.8 (BL) - Remediate 'Configure storage of BitLocker recovery information to AD DS'

Write-Output "Remediating: CIS Control 18.10.9.1.8 (BL) - Configure storage of BitLocker recovery information to AD DS"

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValue = "FDVActiveDirectoryInfoToStore"
$desiredValue = 1

# Set the registry value
try {
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regValue -Value $desiredValue -Type DWord
    Write-Output "Remediated: 'Configure storage of BitLocker recovery information to AD DS' is now set to 'Backup recovery passwords and key packages'."
} catch {
    Write-Output "Error: Failed to set the registry value. Please check permissions and try again."
}

