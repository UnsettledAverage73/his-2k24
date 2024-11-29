# Remedi.ps1 - Configure 'Enable Structured Exception Handling Overwrite Protection (SEHOP)' to 'Enabled'

$title = "CIS Control 18.4.6 (L1) - Ensure 'Enable Structured Exception Handling Overwrite Protection (SEHOP)' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"
$regKey = "DisableExceptionChainValidation"
$expectedValue = 0  # 0 = Enabled

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Enabled' (value = 0)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. 'Enable SEHOP' is now Enabled."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

