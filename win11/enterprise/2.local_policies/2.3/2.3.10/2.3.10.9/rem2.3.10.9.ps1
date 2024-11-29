# Remedi.ps1 - Configure 'Network access: Restrict anonymous access to Named Pipes and Shares' to 'Enabled'

$title = "CIS Control 2.3.10.9 - Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "RestrictNullSessAccess"
$expectedValue = 1

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Value set to: $expectedValue"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

