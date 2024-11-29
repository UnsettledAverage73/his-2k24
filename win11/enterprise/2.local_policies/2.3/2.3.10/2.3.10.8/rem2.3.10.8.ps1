# Remedi.ps1 - Configure 'Network access: Remotely accessible registry paths and sub-paths'

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

