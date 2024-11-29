# remedi.ps1
# Script to disable 'Configuration of wireless settings using Windows Connect Now'

# Registry path and keys
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars"
$RegKeys = @{
    EnableRegistrars           = 0
    DisableUPnPRegistrar       = 1
    DisableInBand802DOT11Registrar = 1
    DisableFlashConfigRegistrar = 1
    DisableWPDRegistrar        = 1
}

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set each key to the recommended value
foreach ($Key in $RegKeys.Keys) {
    Set-ItemProperty -Path $RegPath -Name $Key -Value $RegKeys[$Key] -Type DWord
    Write-Output "Set $Key to $($RegKeys[$Key])."
}

# Verify remediation
foreach ($Key in $RegKeys.Keys) {
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $Key -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $Key
    if ($CurrentValue -eq $RegKeys[$Key]) {
        Write-Output "Verification successful: $Key is set to $CurrentValue."
    } else {
        Write-Output "Verification failed: $Key is set to $CurrentValue. Expected value: $($RegKeys[$Key])."
    }
}
