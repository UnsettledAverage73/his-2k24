# remedi.ps1
# Script to enable "Turn off Microsoft Peer-to-Peer Networking Services"

# Registry key and desired value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Peernet"
$RegValueName = "Disabled"
$DesiredValue = 1

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $RegPath -Name $RegValueName -Value $DesiredValue -Type DWord

# Verify remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegValueName | Select-Object -ExpandProperty $RegValueName -ErrorAction SilentlyContinue
if ($CurrentValue -eq $DesiredValue) {
    Write-Output "Remediation successful: Microsoft Peer-to-Peer Networking Services are turned off."
} else {
    Write-Output "Remediation failed: $RegValueName is set to $CurrentValue. Expected: $DesiredValue."
}
