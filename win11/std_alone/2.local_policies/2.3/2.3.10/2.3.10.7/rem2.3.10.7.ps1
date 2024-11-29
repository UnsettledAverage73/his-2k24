# Remedi.ps1 - Configure 'Network access: Remotely accessible registry paths'

$title = "CIS Control 2.3.10.7 - Ensure 'Network access: Remotely accessible registry paths' is configured"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurePipeServers\Winreg"
$regKey = "AllowedExactPaths"
$expectedValues = @(
    "System\CurrentControlSet\Control\ProductOptions",
    "System\CurrentControlSet\Control\Server Applications",
    "Software\Microsoft\Windows NT\CurrentVersion"
)

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value
    $expectedValueString = $expectedValues -join "`n"
    Set-ItemProperty -Path $regPath -Name Machine -Value $expectedValueString -Type MultiString
    Write-Host "$title - Remediation completed. Values set: $($expectedValues -join ', ')"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

