# Check.ps1 - Verify if 'DisableSavePassword' is set to Enabled

$title = "CIS Control 18.5.4 (L2) - Ensure 'MSS: (DisableSavePassword) Prevent the Dial-Up Password from Being Saved' is set to 'Enabled'"
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\RasMan\Parameters"
$regKey = "DisableSavePassword"
$expectedValue = 1  # Enabled

Write-Host "Checking compliance for: $title"

try {
    # Check if the registry key exists
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey
    if ($currentValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Dial-up password saving is disabled)."
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value: $currentValue)."
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not set)."
}

