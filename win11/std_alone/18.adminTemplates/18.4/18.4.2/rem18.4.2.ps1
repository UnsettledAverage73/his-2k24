# Remedi.ps1 - Configure 'Configure RPC packet level privacy setting for incoming connections' to 'Enabled'

$title = "CIS Control 18.4.2 (L1) - Ensure 'Configure RPC packet level privacy setting for incoming connections' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Print"
$regKey = "RpcAuthnLevelPrivacyEnabled"
$expectedValue = 1  # 1 = Enabled

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Enabled' (value = 1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. RPC packet level privacy is now enabled for incoming connections."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

