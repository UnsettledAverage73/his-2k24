# check.ps1
# Script to check if IPv6 is disabled (DisabledComponents set to 0xff)

# Registry path and key
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters"
$RegKey = "DisabledComponents"
$ExpectedValue = 255

# Check if the registry path exists
if (Test-Path $RegPath) {
    # Get the current value of DisabledComponents
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

    if ($CurrentValue -eq $ExpectedValue) {
        Write-Output "Pass: IPv6 is disabled (DisabledComponents is set to $ExpectedValue)."
    } else {
        Write-Output "Fail: IPv6 is not disabled. Current value: $CurrentValue. Expected value: $ExpectedValue."
    }
} else {
    Write-Output "Fail: Registry path $RegPath does not exist."
}

