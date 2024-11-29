# check.ps1
# Script to check if 'Configuration of wireless settings using Windows Connect Now' is disabled

# Registry path and keys
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars"
$RegKeys = @{
    EnableRegistrars           = 0
    DisableUPnPRegistrar       = 1
    DisableInBand802DOT11Registrar = 1
    DisableFlashConfigRegistrar = 1
    DisableWPDRegistrar        = 1
}

# Check each key
foreach ($Key in $RegKeys.Keys) {
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $Key -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $Key
    if ($CurrentValue -eq $RegKeys[$Key]) {
        Write-Output "Pass: $Key is set to $CurrentValue as expected."
    } else {
        Write-Output "Fail: $Key is set to $CurrentValue. Expected value: $($RegKeys[$Key])."
    }
}
