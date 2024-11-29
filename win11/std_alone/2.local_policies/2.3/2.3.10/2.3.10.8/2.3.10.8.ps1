# Check.ps1 - Verify 'Network access: Remotely accessible registry paths and sub-paths' is configured

$title = "CIS Control 2.3.10.8 - Ensure 'Network access: Remotely accessible registry paths and sub-paths' is configured"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurePipeServers\Winreg"
$regKey = "AllowedPaths"
$expectedValues = @(
    "System\CurrentControlSet\Control\Print\Printers",
    "System\CurrentControlSet\Services\Eventlog",
    "Software\Microsoft\OLAP Server",
    "Software\Microsoft\Windows NT\CurrentVersion\Print",
    "Software\Microsoft\Windows NT\CurrentVersion\Windows",
    "System\CurrentControlSet\Control\ContentIndex",
    "System\CurrentControlSet\Control\Terminal Server",
    "System\CurrentControlSet\Control\Terminal Server\UserConfig",
    "System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration",
    "Software\Microsoft\Windows NT\CurrentVersion\Perflib",
    "System\CurrentControlSet\Services\SysmonLog"
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

