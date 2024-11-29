# Check.ps1 - Verify Network access: Named Pipes that can be accessed anonymously is set to 'None'

$title = "CIS Control 2.3.10.6 - Ensure 'Network access: Named Pipes that can be accessed anonymously' is set to 'None'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "NullSessionPipes"

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop

    if ($regValue.NullSessionPipes -eq $null -or $regValue.NullSessionPipes.Count -eq 0) {
        Write-Host "$title - Status: Compliant (Value: None)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value: $($regValue.NullSessionPipes -join ', '))"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not configured)"
}

