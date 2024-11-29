# Title: CIS Control 18.10.9.1.8 (BL) - Check 'Configure storage of BitLocker recovery information to AD DS'

Write-Output "Checking compliance for: CIS Control 18.10.9.1.8 (BL) - Configure storage of BitLocker recovery information to AD DS"

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValue = "FDVActiveDirectoryInfoToStore"

# Check the registry value
try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction Stop | Select-Object -ExpandProperty $regValue
    if ($currentValue -eq 1) {
        Write-Output "Compliant: 'Configure storage of BitLocker recovery information to AD DS' is set to 'Backup recovery passwords and key packages'."
    } else {
        Write-Output "Non-Compliant: Current value is '$currentValue'. It should be '1' (Backup recovery passwords and key packages)."
    }
} catch {
    Write-Output "Non-Compliant: Registry key or value does not exist."
}

