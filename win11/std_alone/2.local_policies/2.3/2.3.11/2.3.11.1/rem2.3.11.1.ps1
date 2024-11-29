# Remedi.ps1 - Configure 'Network security: Allow Local System to use computer identity for NTLM' to 'Enabled'

$title = "CIS Control 2.3.11.1 - Ensure 'Network security: Allow Local System to use computer identity for NTLM' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "UseMachineId"
$expectedValue = 1

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 1 (Enabled)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. UseMachineId set to 1 (Enabled)"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

