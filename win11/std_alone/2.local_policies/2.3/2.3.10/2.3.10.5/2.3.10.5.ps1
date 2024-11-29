# Check.ps1 - Verify Network access: Let Everyone permissions apply to anonymous users configuration

$title = "CIS Control 2.3.10.5 - Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "EveryoneIncludesAnonymous"

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop

    if ($regValue.EveryoneIncludesAnonymous -eq 0) {
        Write-Host "$title - Status: Compliant (Value: Disabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value: Enabled or Not Configured)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not configured)"
}

