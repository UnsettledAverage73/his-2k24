# Check.ps1 - Verify Network access: Do not allow anonymous enumeration of SAM accounts configuration

$title = "CIS Control 2.3.10.2 - Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "RestrictAnonymousSAM"

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop

    if ($regValue.RestrictAnonymousSAM -eq 1) {
        Write-Host "$title - Status: Compliant (Value: Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value: Disabled or Not Configured)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not configured)"
}

