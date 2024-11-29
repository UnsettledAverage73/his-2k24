# Title: CIS Control 18.10.9.1.9 (BL) - Remediate 'Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives'

Write-Output "Remediating: CIS Control 18.10.9.1.9 (BL) - Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives"

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValue = "FDVRequireActiveDirectoryBackup"
$desiredValue = 0

# Set the registry value
try {
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regValue -Value $desiredValue -Type DWord
    Write-Output "Remediated: 'Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives' is now set to 'False (unchecked)'."
} catch {
    Write-Output "Error: Failed to set the registry value. Please check permissions and try again."
}

