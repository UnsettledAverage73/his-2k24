# Check.ps1 - Check Microsoft network server: Amount of idle time required before suspending session configuration

$title = "CIS Control 2.3.9.1 - Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "AutoDisconnect"

# Retrieve the current registry value
$regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue

if ($regValue) {
    if ($regValue.AutoDisconnect -le 15) {
        Write-Host "$title - Status: Compliant (Value: $($regValue.AutoDisconnect) minutes)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value: $($regValue.AutoDisconnect) minutes)"
    }
} else {
    Write-Host "$title - Status: Non-Compliant (Not Configured)"
}

