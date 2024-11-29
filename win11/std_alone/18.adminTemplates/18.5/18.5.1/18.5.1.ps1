# Check.ps1 - Verify if 'AutoAdminLogon' is disabled

$title = "CIS Control 18.5.1 (L1) - Ensure 'MSS: (AutoAdminLogon) Enable Automatic Logon' is set to 'Disabled'"
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regKey = "AutoAdminLogon"
$expectedValue = 0  # Disabled

Write-Host "Checking compliance for: $title"

try {
    # Check if the registry key exists
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey
    if ($currentValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (AutoAdminLogon is disabled)."
    } else {
        Write-Host "$title - Status: Non-Compliant (Current AutoAdminLogon value: $currentValue)."
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (AutoAdminLogon registry key not found or not set)."
}

