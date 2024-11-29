# Title: CIS Control 18.10.9.1.9 (BL) - Check 'Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives'

Write-Output "Checking compliance for: CIS Control 18.10.9.1.9 (BL) - Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives"

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValue = "FDVRequireActiveDirectoryBackup"

# Check the registry value
try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction Stop | Select-Object -ExpandProperty $regValue
    if ($currentValue -eq 0) {
        Write-Output "Compliant: 'Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives' is set to 'False (unchecked)'."
    } else {
        Write-Output "Non-Compliant: Current value is '$currentValue'. It should be '0' (False)."
    }
} catch {
    Write-Output "Non-Compliant: Registry key or value does not exist."
}

