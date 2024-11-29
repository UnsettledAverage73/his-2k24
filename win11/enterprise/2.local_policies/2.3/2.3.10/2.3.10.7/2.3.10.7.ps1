# Check.ps1 - Verify 'Network access: Remotely accessible registry paths' is configured

$title = "CIS Control 2.3.10.7 - Ensure 'Network access: Remotely accessible registry paths' is configured"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurePipeServers\Winreg"
$regKey = "AllowedExactPaths"
$expectedValues = @(
    "System\CurrentControlSet\Control\ProductOptions",
    "System\CurrentControlSet\Control\Server Applications",
    "Software\Microsoft\Windows NT\CurrentVersion"
)

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name Machine -ErrorAction Stop).Machine

    # Convert to array for comparison
    $regValueArray = $regValue -split "`n"

    # Compare values
    if ($expectedValues | Compare-Object -ReferenceObject $regValueArray -SyncWindow 0) {
        Write-Host "$title - Status: Non-Compliant"
        Write-Host "Expected: $($expectedValues -join ', ')"
        Write-Host "Found: $($regValueArray -join ', ')"
    } else {
        Write-Host "$title - Status: Compliant"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not configured)"
}

