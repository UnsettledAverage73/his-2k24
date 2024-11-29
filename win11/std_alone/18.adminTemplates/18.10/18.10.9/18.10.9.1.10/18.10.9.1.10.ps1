# Title: CIS Control 18.10.9.1.10 (BL) - Check 'Configure use of hardware-based encryption for fixed data drives'

Write-Output "Checking compliance for: CIS Control 18.10.9.1.10 (BL) - Configure use of hardware-based encryption for fixed data drives"

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValue = "FDVHardwareEncryption"

# Check the registry value
try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction Stop | Select-Object -ExpandProperty $regValue
    if ($currentValue -eq 0) {
        Write-Output "Compliant: 'Configure use of hardware-based encryption for fixed data drives' is set to 'Disabled'."
    } else {
        Write-Output "Non-Compliant: Current value is '$currentValue'. It should be '0' (Disabled)."
    }
} catch {
    Write-Output "Non-Compliant: Registry key or value does not exist."
}

