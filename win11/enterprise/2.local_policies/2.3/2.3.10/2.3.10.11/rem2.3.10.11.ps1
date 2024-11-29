# Remedi.ps1 - Configure 'Network access: Shares that can be accessed anonymously' to 'None'

$title = "CIS Control 2.3.10.11 - Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "NullSessionShares"
$expectedValue = ""

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to an empty string (None)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type MultiString
    Write-Host "$title - Remediation completed. Value set to: (empty)"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

