# Check.ps1 - Verify Network access: Allow anonymous SID/Name translation configuration

$title = "CIS Control 2.3.10.1 - Ensure 'Network access: Allow anonymous SID/Name translation' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "TurnOffAnonymousBlock"

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop

    if ($regValue.TurnOffAnonymousBlock -eq 1) {
        Write-Host "$title - Status: Compliant (Value: Disabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value: Enabled or Not Configured)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not configured)"
}

