# Check.ps1 - Verify 'Network access: Shares that can be accessed anonymously' is set to 'None'

$title = "CIS Control 2.3.10.11 - Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "NullSessionShares"
$expectedValue = ""

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value is empty (i.e., no shares listed)
    if (-not $regValue) {
        Write-Host "$title - Status: Compliant (Value is empty, as expected)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Shares listed: $regValue)"
    }
} catch {
    Write-Host "$title - Status: Compliant (Registry key not found, default behavior)"
}

