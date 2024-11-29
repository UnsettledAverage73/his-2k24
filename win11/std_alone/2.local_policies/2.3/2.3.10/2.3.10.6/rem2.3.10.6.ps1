# Remedi.ps1 - Configure Network access: Named Pipes that can be accessed anonymously to 'None'

$title = "CIS Control 2.3.10.6 - Ensure 'Network access: Named Pipes that can be accessed anonymously' is set to 'None'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "NullSessionPipes"

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to None (blank)
    Remove-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue
    Write-Host "$title - Remediation completed. Setting 'Named Pipes that can be accessed anonymously' to 'None'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

